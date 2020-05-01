#
# Setup
#
# Set the location based on whichever repo you are in
break # do not remove
Set-Location $env:PresentationDemosRoot

$rootDir = (Get-Location).Path
$internalDir = Join-Path -Path $rootdir -ChildPath 'internal'
Remove-Item -Path $internalDir -Recurse -Force
# Remove testrepo packages
Remove-Item -Path 'C:\tools\chocolatey.server\App_Data\Packages' -Recurse -Force -ErrorAction SilentlyContinue
# Remove prodrepo packages
Remove-Item -Path 'C:\tools\chocolatey.serverB\App_Data\Packages' -Recurse -Force -ErrorAction SilentlyContinue
iisreset
$null = New-Item -Path $internalDir -ItemType Directory -ErrorAction SilentlyContinue
choco source remove -n=testrepo
choco source remove -n=prodrepo
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
ii $env:LocalChocoPackages

# We have added a test repository and a production repository so lets add them now
Write-Host "`n"
choco source add --name='testrepo' `
    --source='http://localhost/chocolatey' `
    --priority='2'
Write-Host "`n"
choco source add --name='prodrepo' `
    --source='http://localhost:81/chocolatey' `
    --priority='2'

# lets look at the source again - we have those new repositories added which means we can take packages from them
Write-Host "`n"
choco source list

# Lets have a look to see what packages are on our test and production repository
Write-Host "`nTest Repository:"
choco list --source='testrepo'
Write-Host "`nProduction Repository:"
choco list --source='prodrepo'

# # # # # # # # # # # # # # # #
#
# Demo 2 - Internalizing A Package
#
# # # # # # # # # # # # # # # #

# Download launchy as we are going to internalize it
# make sure you have internet connectivity
$pkgToInternalize = 'launchy'
Write-Host "`nDownloading '$pkgToInternalize' package:"
choco download launchy --source='https://chocolatey.org/api/v2/' `
    --output-directory=$(Join-Path -Path $internalDir -ChildPath "$pkgToInternalize-manual")

# Lets have a look at the chocolateyInstall.ps1 for Launchy. 
# In order to manually internalize it do the following:
#
# 1. Download the binary in the URL
# 2. Place the binary in the package tools folder
# 3. Update the location of the binary being passed to the `Install-ChocolateyInstallPackage` cmdlet
# 4. Run `choco pack`

# Lets now use the package internalizer to do it - a C4B feature
Write-Host "`nInternalize '$pkgToInternalize' package:"
choco download $pkgToInternalize --source="'https://chocolatey.org/api/v2/'" --internalize `
    --internalize-all-urls --append-use-original-location `
    --output-directory=$(join-path $internalDir "$pkgToInternalize-auto")

# Lets see how long that took
$cmdTime = $(history)[-1]
$timeTaken = ($cmdTime.EndExecutionTime - $cmdTime.StartExecutionTime).TotalSeconds
Write-Host "`nTime taken to internalize the '$pkgToInternalize' package: $timeTaken seconds!" -ForegroundColor Green

# # # # # # # # # # # # # # # #
#
# Demo 3 - Look at the Pester Tests
#
# # # # # # # # # # # # # # # #

code C:\scripts\Test-Package.ps1

# # # # # # # # # # # # # # # #
#
# Scenario 1 - Prepare OpenSSH for the Devs
#
# # # # # # # # # # # # # # # #

# 1. Have a look at the packages in the test and prod repo to compare later
choco list --source=testrepo
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
choco list --source=testrepo
choco list --source=prodrepo

# # # # # # # # # # # # # # # #
#
# Scenario 2 - Push New App By Dev Team
#
# The Development Team have finished the app they have been working on for so long;
#
# # # # # # # # # # # # # # # #

# The app is built and, through their build pipeline,
# Run the simple build script
Set-Location (Join-Path -Path $rootDir -ChildPath 'daisy')
.\build.ps1

# Show video if necessary
# choco push daisy --source='http://localhost:81/chocolatey' --api-key='chocolateyrocks'

# Check 'daisy' is there
choco list --source=testrepo

# Once done check it's in Production
choco list --source=prodrepo

# # # # # # # # # # # # # # # #
#
# Scenario 3 - Your app' has a security vulnerability
#
# 1. The version of 'Your app' you use in the business has a security vulnerability and you need to update immediately!
# 2. New version of 'Your app' is available on the Chocolatey Community Repository;
# 3. Your task list:
#   1. Internalize the latest version of putty.install from the Chocolatey Community Repository;
#   2. Push it to your test repository;
#   3. Test it in your test environment and on your Golden Images;
#   4. Push it to your production repository;
#   5. Deploy it to the business;
#
# # # # # # # # # # # # # # # #

# Lets set this up by uploading putty.install to both test and production
choco download putty.install --version 0.70 --source=local --outputdirectory $internalDir --ignoredependencies
choco push $(Join-Path -Path $internalDir 'putty.install.0.70.nupkg') --source=http://localhost/chocolatey --api-key='chocolateyrocks'
choco push $(Join-Path -Path $internalDir 'putty.install.0.70.nupkg') --source=http://localhost:81/chocolatey --api-key='chocolateyrocks'
Write-Host "`n"
choco list putty.install --source=testrepo
Write-Host "`n"
choco list putty.install --source=prodrepo

# Update outdated app in your test repository - run the job in Jenkins

# Lets have a look at the new versions in the repositories
choco list --source=testrepo --all-versions
choco list --source=prodrepo --all-versions