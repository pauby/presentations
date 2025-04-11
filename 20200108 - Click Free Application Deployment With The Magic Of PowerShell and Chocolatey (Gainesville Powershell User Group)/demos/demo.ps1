#######################################
#
# Setup
#
#######################################
break # do not remove
Set-Location 'c:\presentations'
Set-Location 'c:\private-presentations'

$rootDir = (Get-Location).Path
$internalDir = Join-Path -Path $rootdir -ChildPath 'internal'
$null = Get-Process -Name '7zfm', 'Notepad' -ErrorAction SilentlyContinue | Stop-Process
Remove-Item -Path $internalDir -Recurse -Force -ErrorAction SilentlyContinue
$null = New-Item -Path $internalDir -ItemType Directory
choco uninstall autohotkey.portable -y
Clear-Host

#######################################
#
# Demo 1a: choco new
#
#######################################

# Lets look at creating a very simple package
# The command creates a set of package files from a template
# includes helpful todo's.
Set-Location -Path $internalDir
choco new mypackage

# A package as a minimum must have a .nuspec which has a dependency or a files section
# if no files section then it will by default add everything in the folder and subfolders
Set-Location mypackage
choco pack
& 'C:\Program Files\7-Zip\7zFM.exe' $(Join-Path -Path $internalDir -ChildPath 'mypackage\mypackage.1.0.0.nupkg')

#######################################
#
# Demo 1b: Lets look at an existing package
#
#######################################

# Lets look at a meta packages, the dependent package and the Java package

# Lets look at the putty and putty package and see that it is a meta package
$latest = Get-ChildItem (Join-Path -Path $env:LocalChocoPackages -ChildPath 'putty.install.*.nupkg') `
    | Sort-Object -Property LastWriteTime | Select-Object -First 1
Copy-Item -Path $latest -Destination $internalDir
Set-Location $internalDir
& 'C:\Program Files\7-Zip\7zFM.exe' ($latest.Name)

# Lets look at an Oracle package
$splat = @{
    Uri     = 'https://www.chocolatey.org/api/v2/package/jre8/8.0.211'
    OutFile = Join-Path -Path $internalDir -ChildPath 'jre8.8.0.211.nupkg'
}
Invoke-WebRequest @splat
& 'C:\Program Files\7-Zip\7zFM.exe' $splat.OutFile

#######################################
#
# Demo 1c: Badly Behaved Installers
#
#######################################

# Two ways to deal with this - 
# 1. MSI Repackaging (organisations)
# 2. AutoHotkey (Chocolatey Community Repository)

# Does the audience know what Autohotkey is?
# Lets look at the traditional way to do this
$latest = Get-ChildItem (Join-Path -Path $env:LocalChocoPackages -ChildPath 'veracrypt.*.nupkg') |
    Sort-Object -Property LastWriteTime | Select-Object -First 1
Copy-Item -Path $latest -Destination $internalDir
7z e $latest.Name 'tools\files\VeraCrypt%20Setup%201.23-Hotfix-2.exe'
.\VeraCrypt%20Setup%201.23-Hotfix-2.exe

# Now lets install Veracrypt - all of it is automated
choco install veracrypt --source $env:LocalChocoPackages -y

# And uninstall Veracrypt - all of it is automated
choco uninstall veracrypt -y

# Lets look at the chocolateyInstall.ps1 and chocolateyUninstall.ps1 file 
# and the Autohotkey file
& 'C:\Program Files\7-Zip\7zFM.exe' ($latest.Name)

#######################################
#
# Demo 2a: Pester testing
#
#######################################

# have a look at the package tests

# try mypackage - expecting errors on projecturl and install / uninstall
$testScript = Join-Path $rootDir -ChildPath 'package.tests.ps1'
$packagePath = Join-Path -Path $internalDir -ChildPath 'mypackage\mypackage.1.0.0.nupkg'
$packageName = 'mypackage'
Invoke-Pester -Script @{ Path = $testScript; Parameters = @{ Path = $packagePath; Name = $packageName } }

# try putty.install - no errors expected
$packagePath = (Get-ChildItem -Path (Join-Path -Path $internalDir -ChildPath 'putty.install.*.nupkg')).FullName
$packageName = 'putty.install'
Invoke-Pester -Script @{ Path = $testScript; Parameters = @{ Path = $packagePath; Name = $packageName } }

#######################################
#
# Demo 2b: AU
#
#######################################

# Documentation
Start-Process -FilePath 'https://chocolatey.org/docs/automatic-packages'

# dbatools update
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pauby/ChocoPackages/master/automatic/dbatools/update.ps1' `
    -OutFile (Join-Path $internalDir -ChildPath 'dbatools-update.ps1')
#Start-Process -FilePath 'https://github.com/pauby/ChocoPackages/tree/master/automatic/dbatools'

# jenkins update
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pauby/ChocoPackages/master/automatic/jenkins/update.ps1' `
    -OutFile (Join-Path $internalDir -ChildPath 'jenkins-update.ps1')
#Start-Process -FilePath 'https://github.com/pauby/ChocoPackages/tree/master/automatic/jenkins'