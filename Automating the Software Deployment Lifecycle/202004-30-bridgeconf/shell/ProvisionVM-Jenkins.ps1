# Taken from https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
function Add-Shortcut {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $LinkPath,

        [Parameter(Mandatory)]
        [string]
        $TargetPath,

        [string]
        $Arguments,

        [switch]
        $AsAdmin
    )

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($LinkPath)
    $Shortcut.TargetPath = $TargetPath

    if ($Arguments) {
        $Shortcut.Arguments = $Arguments
    }

    $Shortcut.Save()

    if ($AsAdmin.IsPresent) {
        $bytes = [System.IO.File]::ReadAllBytes($LinkPath)
        $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
        [System.IO.File]::WriteAllBytes($LinkPath, $bytes)
    }
}

$vagrantSecrets = Get-Content -Path '\vagrant\vagrant-secret.json' | ConvertFrom-Json

\shell\ConfigureAutoLogin.ps1
\shell\PrepareWindows.ps1
\shell\SetRegion.ps1 -Region 'UK'
\shell\InstallChocolatey.ps1 -UseLocalSource
\shell\DeployChocolateyLicense.ps1 -LicenseType Bus

Write-Host 'Remove Chocolatey Default Sources'
choco source remove -n='chocolatey'
choco source remove -n='chocolatey.licensed'

$vagrantSecrets.EnvironmentVariables | ForEach-Object {
    Write-Host "Setting machine wide environment variable '$($_.name)'."
    [Environment]::SetEnvironmentVariable($_.Name, $_.value, "Machine")
}

\shell\NotifyGuiAppsOfEnvironmentChanges.ps1
\shell\InstallVMGuestTools.ps1
\shell\InstallBGInfo.ps1
\shell\InstallChocoPackage.ps1 -Name vscode, vscode-powershell, git, chromium, pester, psscriptanalyzer, zoomit, notepadplusplus, nuget.commandline
\shell\ProvisionJenkins.ps1 -ConfigurationPath 'c:\vagrant\assets\jenkins-config.zip'

Write-Host "Disable Windows Firewall"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Write-Host "Copy Jenkins Scripts Locally"
New-Item -Path 'c:\scripts' -ItemType Directory -Force | Out-Null
Copy-Item -Path 'c:\vagrant\assets\jenkins-scripts\*' -Destination 'c:\scripts\'

Write-Host "Allow Outbound Winrm"
# we set the environment variables earlier but we can use these here as the session doesn't recognise them yet
$dnsName = ($vagrantSecrets.EnvironmentVariables | where name -eq 'ChocoTest_DnsName').Value
winrm set winrm/config/client "@{TrustedHosts=""$dnsName,client""}"

Write-Host "Manage Desktop Shortcuts"
Remove-Item -Path 'c:\users\public\desktop\*.lnk' -Force -ErrorAction SilentlyContinue | Out-Null

Add-Shortcut -LinkPath "$Home\Desktop\VS Code Presentation.lnk" `
    -TargetPath 'C:\Program Files\Microsoft VS Code\Code.exe' -AsAdmin
Add-Shortcut -LinkPath "$Home\Desktop\Open Jenkins.lnk" `
    -TargetPath 'C:\\Program Files\Internet Explorer\iexplore.exe' `
    -Arguments "http://localhost:8080"
Add-Shortcut -LinkPath (Join-Path -Path ([Environment]::GetFolderPath('Startup')) -ChildPath 'Zoomit.lnk') `
    -TargetPath (Join-Path -Path $env:ChocolateyInstall -Childpath 'bin\zoomit.exe')

# Launch Zoomit
& (Join-Path -Path $env:ChocolateyInstall -Childpath 'bin/zoomit.exe')
