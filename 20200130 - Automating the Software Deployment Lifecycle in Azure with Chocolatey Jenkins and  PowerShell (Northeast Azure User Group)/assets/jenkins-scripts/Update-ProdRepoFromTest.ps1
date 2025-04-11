<#
.NOTES
    Written by Paul Broadwith (paul@pauby.com) October 2018
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]
    $ProdRepo,

    [Parameter(Mandatory)]
    [string]
    $ProdRepoApiKey,

    [Parameter(Mandatory)]
    [string]
    $TestRepo
)

. .\ConvertTo-ChocoObject.ps1

# get all of the packages from the test repo
Write-Verbose "Getting packages from 'testrepo'."
$testPkgs = choco.exe list --source $TestRepo -r | ConvertTo-ChocoObject
Write-Verbose "Getting packages from 'prodrepo'."
$prodPkgs = choco.exe list --source $ProdRepo -r | ConvertTo-ChocoObject
$tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID

Write-Verbose "Comparing retrieved packages from 'testrepo' and prodrepo'."
if ($null -eq $testPkgs) {
    Write-Verbose "Test repository appears to be empty. Nothing to push to production."
    exit 0
}
elseif ($null -eq $prodPkgs) {
    $pkgs = $testPkgs
}
else {
    $pkgs = Compare-Object -ReferenceObject $testpkgs -DifferenceObject $prodpkgs -Property name, version |
        Where-Object SideIndicator -eq '<='
}

$pkgs | ForEach-Object {
    Write-Verbose "Downloading package '$($_.name)' to '$tempPath'."
    choco.exe download $_.name --no-progress --output-directory=$tempPath --source=$TestRepo --force --limitoutput --ignore-dependencies

    if ($LASTEXITCODE -eq 0) {
        $pkgPath = (Get-Item -Path (Join-Path -Path $tempPath -ChildPath "$($_.name)*.nupkg")).FullName
        Write-Verbose "Package path: $pkgpath"
        Write-Verbose "Executing test scripts against package '$($_.name)'."
        $failed = (Invoke-Pester -Script @{ Path = '.\Test-Package.ps1'; Parameters = @{ Path = $pkgPath; Name = $_.name; Source = $TestRepo } } -Passthru).FailedCount
        if ($failed) {
            break
        }

        # If package testing is successful ...
        if (-not $failed) {
            Write-Verbose "Pushing downloaded package '$(Split-Path -Path $pkgPath -Leaf)' to production repository '$ProdRepo'."
            choco push $pkgPath -source $ProdRepo -apikey $ProdRepoApiKey

            if ($LASTEXITCODE -eq 0) {
                Write-Verbose "Pushed package successfully."
            }
            else {
                Write-Verbose "Could not push package."
            }
        }
        else {
            Write-Verbose "Package testing failed."
        }

        Remove-Item -Path $pkgPath -Force
    }
    else {
        Write-Verbose "Could not download package."
    }
}
