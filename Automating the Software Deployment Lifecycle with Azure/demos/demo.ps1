#
# Setup
#
# Set the location based on whichever repo you are in
break # do not remove
Set-Location 'c:\presentations'
$rootDir = (Get-Location).Path
$internalDir = Join-Path -Path $rootdir -ChildPath 'internal'
Remove-Item -Path $internalDir -Recurse -Force -ErrorAction SilentlyContinue
$null = New-Item -Path $internalDir -ItemType Directory -ErrorAction SilentlyContinue
choco source remove -n=testrepo
choco source remove -n=prodrepo
nuget source remove -name testrepo
nuget source remove -name prodrepo
cls

# # # # # # # # # # # # # # # #
#
# Demo 1 - Chocolatey Sources
#
# # # # # # # # # # # # # # # #

# List the Chocolatey sources and explain each one
# Organizations are recommended to turn off the Chocolatey Community Repositiry
choco source list

# Look at local source
ii C:\packages

# Lets' create the Azure DevOps Chocolatey Sources
Start-Process 'https://pauby.visualstudio.com/demo-repo'

# We have added a test repository and a production repository so lets add them now
# replace /v3/index.json with /v2
$testrepoSource = 'https://pauby.pkgs.visualstudio.com/_packaging/test-06/nuget/v2'
$prodrepoSource = 'https://pauby.pkgs.visualstudio.com/_packaging/prod-06/nuget/v2'
Write-Host "`n"
choco source add --name='testrepo' `
    --source=$testrepoSource `
    --priority='2' `
    --user=$env:AzureDevOps_Username `
    --password=$env:AzureDevOps_Password
Write-Host "`n"
choco source add --name='prodrepo' `
    --source=$prodrepoSource `
    --priority='2' `
    --user=$env:AzureDevOps_Username `
    --password=$env:AzureDevOps_Password

$password = ConvertTo-SecureString 'vagrant' -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("client\vagrant", $password)
$session = New-PSSession -ComputerName 'client' -Credential $creds
Invoke-Command -Session $session -ScriptBlock {
    choco feature disable -n=usePackageRepositoryOptimizations
    choco source remove --name='prodrepo'
    choco source add --name='prodrepo' `
        --source=$Using:prodrepoSource `
        --priority='2' `
        --user=$Using:env:AzureDevOps_Username `
        --password=$Using:env:AzureDevOps_Password
}

$password = ConvertTo-SecureString $env:chocotest_password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("$($env:chocotest_username)", $password)
$session = New-PSSession -ComputerName $env:chocotest_dns -Credential $creds 
Invoke-Command -Session $session -ScriptBlock {
    choco feature disable -n=usePackageRepositoryOptimizations
    choco source remove --name='testrepo'
    choco source add --name='testrepo' `
        --source=$Using:testrepoSource `
        --priority='2' `
        --user=$Using:env:AzureDevOps_Username `
        --password=$Using:env:AzureDevOps_Password
}

# lets look at the source again - we have those new repositories added which means we can take packages from them
Write-Host "`n"
choco source list

# as we need nuget to push packages lets add the sources there too
# explain why we are storing the pasword in plain text
Write-Host "`n"
nuget source remove -name nuget.org
nuget source add -name testrepo `
    -source $testrepoSource `
    -username $env:AzureDevOps_Username `
    -password $env:AzureDevOps_Password `
    -StorePasswordInClearText
Write-Host "`n"
nuget source add -name prodrepo `
    -source $prodrepoSource `
    -username $env:AzureDevOps_Username `
    -password $env:AzureDevOps_Password `
    -StorePasswordInClearText

# Copy the nuget.config file so we can use it in Jenkins jobs
New-Item -Path 'c:\nuget' -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
Copy-Item -Path (Join-Path -Path $env:APPDATA -ChildPath 'nuget\nuget.config') -Destination 'c:\nuget\' -Force -ErrorAction Stop | Out-Null

# Lets have a look to see what packages are on our test and production repository
Write-Host "`n"
choco list --source='testrepo'
Write-Host "`n"
choco list --source='prodrepo'

# # # # # # # # # # # # # # # #
#
# Demo 2 - Internalizing A Package
#
# # # # # # # # # # # # # # # #

# Download launchy as we are going to internalize it
# make sure you have internet connectivity
Write-Host "`n"
choco download launchy --source='https://chocolatey.org/api/v2/' `
    --output-directory=$(Join-Path -Path $internalDir -ChildPath 'launchy-manual')

# Lets have a look at the chocolateyInstall.ps1 for Launchy. 
# In order to manually internalize it do the following:
#
# 1. Download the binary in the URL
# 2. Place the binary in the package tools folder
# 3. Update the location of the binary being passed to the `Install-ChocolateyInstallPackage` cmdlet
# 4. Run `choco pack`

# Lets now use the package internalizer to do it - a C4B feature
Write-Host "`n"
choco download launchy --internalize --internalize-all-urls --append-use-original-location `
    --output-directory=$(join-path $internalDir 'launchy-auto') 

# Lets see how long that took
Write-Host "`n"
$cmdTime = $(history)[-1]
($cmdTime.EndExecutionTime - $cmdTime.StartExecutionTime).TotalSeconds

# # # # # # # # # # # # # # # #
#
# Demo 3 - Look at the Jenkins Code
#
# # # # # # # # # # # # # # # #

code c:\scripts

# # # # # # # # # # # # # # # #
#
# Demo 4 - Prepare OpenSSH for the Devs
#
# # # # # # # # # # # # # # # #

# 1. Have a look at the packages in the test and prod repo to compare later
Write-Host "`n"
choco list --source=testrepo
Write-Host "`n"
choco list --source=prodrepo

# 2. Run the Internalize Packages job in Jenkins and use openssh 
# in P_PKG_LIST
#    Show video of this and then push the packages to the repo
# $curDir = Get-Location
# Set-Location (Join-Path -Path $rootDir -ChildPath 'package-backup')
# choco push openssh --source=testrepo
# choco push openssh --source=prodrepo
# Set-Location $curDir

# 3. Have a look at the packages in the test and prod repo to compare later
Write-Host "`n"
choco list --source=testrepo
Write-Host "`n"
choco list --source=prodrepo

# # # # # # # # # # # # # # # #
#
# Demo 5 - Push New App By Dev Team
#
# The Development Team have finished the app they have been working on for so long;
# # # # # # # # # # # # # # # #

# The app is built and, through their build pipeline, 
# Run the simple build script
Set-Location (Join-Path -Path $rootDir -ChildPath 'demos\daisy')
.\build.ps1

# Show video if necessary

# Check 'daisy' is there
Write-Host "`n"
choco list --source=testrepo

# Once done check it's in Production
Write-Host "`n"
choco list --source=prodrepo

# # # # # # # # # # # # # # # #
#
# Demo 6 - 7Zip has a security vulnerability
#
# 1. The version of 7Zip you use in the business has a security vulnerability and you need to update immediately!
# 2. New version of 7Zip is available on the Chocolatey Community Repository;
# 3. Your task list:
#   1. Internalize the latest version of 7zip.install from the Chocolatey Community Repository;
#   2. Push it to your test repository;
#   3. Test it in your test environment and on your Golden Images;
#   4. Push it to your production repository;
#   5. Deploy it to the business;
#
# # # # # # # # # # # # # # # #

# Lets set this up by uploading 7zip.install to both test and production
choco download 7zip.install --version 18.6 --source=local `
    --outputdirectory $internalDir --ignoredependencies
nuget push $(Join-Path -Path $internalDir '7zip.install.18.6.nupkg') `
    -source 'testrepo' -apikey $env:AzureDevOps_ApiKey
nuget push $(Join-Path -Path $internalDir '7zip.install.18.6.nupkg') `
    -source 'prodrepo' -apikey $env:AzureDevOps_ApiKey
Write-Host "`n"
choco list 7zip.install --source=testrepo
Write-Host "`n"
choco list 7zip.install --source=prodrepo

# Update outdated app in your test repository - run the job in Jenkins

# Lets have a look at the new versions in the repositories
Write-Host "`n"
choco list 7zip.install --source=testrepo --all-versions
Write-Host "`n"
choco list 7zip.install --source=prodrepo --all-versions

# Go to the client machine and run a Choco upgrade using ChocolateyGui