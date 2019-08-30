#
# Go and manually remove fork https://github.com/pauby/git-fundamentals-demo
#
$thisLoc = Get-Location
$path = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid
$null = New-Item -Path $path -ItemType Directory
Set-Location $path
git clone https://github.com/psdevopsug/git-fundamentals-demo
Set-Location 'git-fundamentals-demo'

Get-ChildItem -Recurse |
    Select -ExpandProperty FullName |
    Where {$_ -notlike '.git*'} |
    sort length -Descending |
    Remove-Item -force


git add .
git commit -m 'Reset repository'
git push -f

Set-Location 'C:\gitfundamentalstalk'
Remove-Item * -Force -Recurse

Set-Location $thisLoc
