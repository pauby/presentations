<#
.NOTES
    Written by Paul Broadwith (paul@pauby.com) October 2018
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string[]]
    $Name,

    [ValidateScript( { Test-Path $_ })]
    [string]
    $OutputDirectory = (Join-Path -Path $env:SystemDrive -ChildPath "jenkins-packages"),

    [Version]
    $Version,

    [switch]
    $Force
)

function Test-PackageExist ($Name, $Version, $PackagePath) {
    if ($Version) {
        $Name += ".$Version"
    }
    else {
        $Name += ".*"
    }

    $Name += ".nupkg"

    Test-Path -Path (Join-Path -Path $PackagePath -ChildPath $Name)
}

# start from a clean slate
if (Test-Path -Path $OutputDirectory) {
    Remove-Item -Path $OutputDirectory -Force -Recurse
}
New-Item -Path $OutputDirectory -ItemType Directory -Force

# Go through each package name provided and internalize it
$params = "--internalize --internalize-all-urls --append-use-original-location --source=""'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/'"" --no-progress --limitoutput"
$Name | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-PackageExist -Name $_ -Version $Version -PackagePath $OutputDirectory))) {
        Write-Host "Internalizing package '$_' from the Chocolatey Community Repository." -ForegroundColor Green
        $cmd = "choco download $_ --output-directory=$OutputDirectory $params "
        if ($Force.IsPresent) {
            $cmd += "--force "
        }
        Write-Verbose "Running '$cmd'."
        Invoke-Expression -Command $cmd
    }
    else {
        Write-Warning "Skipping internalizing package '$_' as it already exists in '$OutputDirectory'."
        Write-Warning "To internalize this package anyway, use the -Force parameter."
    }
}