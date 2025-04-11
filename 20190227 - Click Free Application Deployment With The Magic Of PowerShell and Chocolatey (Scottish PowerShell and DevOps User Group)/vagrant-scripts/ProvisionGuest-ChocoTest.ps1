Write-Host "Removing Unneeded Chocolatey Sources"
choco source remove --name='local'
choco source remove --name='chocolatey'