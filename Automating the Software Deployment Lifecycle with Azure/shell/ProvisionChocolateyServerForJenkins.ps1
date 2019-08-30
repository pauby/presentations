Write-Host "Installing Chocolatey.Server..."

$firstSiteName = 'ChocolateyServerA'
$firstAppPoolName = 'ChocolateyServerAAppPool'
$firstSitePath = 'c:\tools\chocolatey.server'
$secondSiteName = 'ChocolateyServerB'
$secondAppPoolName = 'ChocolateyServerBAppPool'
$secondSitePath = 'c:\tools\chocolatey.serverB'

function Add-Acl {
    [CmdletBinding()]
    Param (
        [string]$Path,
        [System.Security.AccessControl.FileSystemAccessRule]$AceObject
    )

    Write-Verbose "Retrieving existing ACL from $Path"
    $objACL = Get-Acl -Path $Path
    $objACL.AddAccessRule($AceObject)
    Write-Verbose "Setting ACL on $Path"
    Set-Acl -Path $Path -AclObject $objACL
}

function New-AclObject {
    [CmdletBinding()]
    Param (
        [string]$SamAccountName,
        [System.Security.AccessControl.FileSystemRights]$Permission,
        [System.Security.AccessControl.AccessControlType]$AccessControl = 'Allow',
        [System.Security.AccessControl.InheritanceFlags]$Inheritance = 'None',
        [System.Security.AccessControl.PropagationFlags]$Propagation = 'None'
    )

    New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($SamAccountName, $Permission, $Inheritance, $Propagation, $AccessControl)
}

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install standard packages."
    Exit 1
}

# Install Chocolatey.Server prereqs
Import-Module -Name ServerManager
Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45
#choco.exe install IIS-WebServer --source windowsfeatures
#choco.exe install IIS-ASPNET45 --source windowsfeatures

# Install Chocolatey.Server
choco.exe upgrade chocolatey.server -y

# Copy extracted files for Chocolatey.Server to create a new instance
Copy-Item $firstSitePath -Destination $secondSitePath -Recurse -Force

# Step by step instructions here https://chocolatey.org/docs/how-to-set-up-chocolatey-server#setup-normally
# Import the right modules
Import-Module WebAdministration
# Disable or remove the Default website
Get-Website -Name 'Default Web Site' | Stop-Website
Set-ItemProperty "IIS:\Sites\Default Web Site" serverAutoStart False    # disables website

# Set up an app pool for Chocolatey.ServerA. Ensure 32-bit is enabled and the managed runtime version is v4.0 (or some version of 4). Ensure it is "Integrated" and not "Classic".
New-WebAppPool -Name $firstAppPoolName -Force -ErrorAction SilentlyContinue
Set-ItemProperty IIS:\AppPools\$firstAppPoolName enable32BitAppOnWin64 True       # Ensure 32-bit is enabled
Set-ItemProperty IIS:\AppPools\$firstAppPoolName managedRuntimeVersion v4.0       # managed runtime version is v4.0
Set-ItemProperty IIS:\AppPools\$firstAppPoolName managedPipelineMode Integrated   # Ensure it is "Integrated" and not "Classic"
Restart-WebAppPool -Name $firstAppPoolName   # likely not needed ... but just in case

# Set up an app pool for Chocolatey.ServerB. Ensure 32-bit is enabled and the managed runtime version is v4.0 (or some version of 4). Ensure it is "Integrated" and not "Classic".
New-WebAppPool -Name $secondAppPoolName -Force -ErrorAction SilentlyContinue
Set-ItemProperty IIS:\AppPools\$secondAppPoolName enable32BitAppOnWin64 True       # Ensure 32-bit is enabled
Set-ItemProperty IIS:\AppPools\$secondAppPoolName managedRuntimeVersion v4.0       # managed runtime version is v4.0
Set-ItemProperty IIS:\AppPools\$secondAppPoolName managedPipelineMode Integrated   # Ensure it is "Integrated" and not "Classic"
Restart-WebAppPool -Name $secondAppPoolName   # likely not needed ... but just in case

# Set up an IIS website pointed to the install location and set it to use the app pool.
New-Website -Name $firstSiteName -ApplicationPool $firstAppPoolName -PhysicalPath $firstSitePath -Port 80 -Force

# Set up an IIS website pointed to the install location and set it to use the app pool.
New-Website -Name $secondSiteName -ApplicationPool $secondAppPoolName -PhysicalPath $secondSitePath -Port 81 -Force

# Add permissions to c:\tools\chocolatey.server:
'IIS_IUSRS', 'IUSR', "IIS APPPOOL\$firstAppPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'ReadAndExecute' -Inheritance 'ContainerInherit', 'ObjectInherit'
    Add-Acl -Path $firstSitePath -AceObject $obj
}

# Add permissions to c:\tools\chocolatey.serverB:
'IIS_IUSRS', 'IUSR', "IIS APPPOOL\$secondAppPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'ReadAndExecute' -Inheritance 'ContainerInherit', 'ObjectInherit'
    Add-Acl -Path $secondSitePath -AceObject $obj
}

# Add the permissions to the App_Data subfolder:
$firstAppdataPath = Join-Path -Path $firstSitePath -ChildPath 'App_Data'
'IIS_IUSRS', "IIS APPPOOL\$firstAppPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'Modify' -Inheritance 'ContainerInherit', 'ObjectInherit'
    Add-Acl -Path $firstAppdataPath -AceObject $obj
}

# Add the permissions to the App_Data subfolder:
$secondAppdataPath = Join-Path -Path $secondSitePath -ChildPath 'App_Data'
'IIS_IUSRS', "IIS APPPOOL\$secondAppPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'Modify' -Inheritance 'ContainerInherit', 'ObjectInherit'
    Add-Acl -Path $secondAppdataPath -AceObject $obj
}
