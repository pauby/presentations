<#
.NOTES
    Written by Paul Broadwith (paul@pauby.com) October 2018
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]
    $LocalRepo,

    [Parameter(Mandatory)]
    [string]
    $LocalRepoApiKey,

    [Parameter(Mandatory)]
    [string]
    $RemoteRepo
)

. .\ConvertTo-ChocoObject.ps1

Write-Verbose "Getting list of local packages from '$LocalRepo'."
$localPkgs = choco.exe list --source $LocalRepo --limitoutput | ConvertTo-ChocoObject
Write-Verbose "Retrieved list of $(($localPkgs).count) packages from '$Localrepo'."

# version of Chocolatey > 0.10.13 exit with code 2 for no results - this is not
# an error so we need to capture it and return it as 0 as Jenkins expects 
# 0 = SUCCESS and !0 = FAILURE
if ($LASTEXITCODE -eq 2) {
    exit 0
}

$localPkgs | ForEach-Object {
    Write-Verbose "Getting remote package information for '$($_.name)'."
    $remotePkg = choco.exe list $_.name --source $RemoteRepo --exact --limitoutput | ConvertTo-ChocoObject

    if (-not $null -eq $remotepkg -and ([version]($remotePkg.version) -gt ([version]$_.version))) {
        Write-Verbose "Package '$($_.name)' has a remote version of '$($remotePkg.version)' which is later than the local version '$($_.version)'."
        Write-Verbose "Internalizing package '$($_.name)' with version '$($remotePkg.version)'."
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
        choco.exe download $_.name --no-progress --internalize --force --internalize-all-urls `
            --append-use-original-location --output-directory=$tempPath --source=$RemoteRepo --limitoutput

        if ($LASTEXITCODE -eq 0) {
            Write-Verbose "Pushing package '$($_.name)' to local repository '$LocalRepo'."
            (Get-Item -Path (Join-Path -Path $tempPath -ChildPath "*.nupkg")).fullname | ForEach-Object {
                nuget push $_ -source $LocalRepo -apikey $LocalRepoApiKey -configfile c:\\nuget\\nuget.config
                if ($LASTEXITCODE -eq 0) {
                    Write-Verbose "Package '$($_.name)' pushed to '$LocalRepo'."
                }
                else {
                    Write-Verbose "Package '$($_.name)' could not be pushed to '$LocalRepo'.`nThis could be because it already exists in the repository at a higher version and can be mostly ignored. Check error logs."
                }
            }
        }
        else {
            Write-Verbose "Failed to download package '$($_.name)'"
        }
    }
    else {
        if ($null -eq $remotePkg) {
            Write-Verbose "Package '$($_.name)' does not exist in the remote. This may be expected."
        }
        else {
            Write-Verbose "Package '$($_.name)' has a remote version of '$($remotePkg.version)' which is not later than the local version '$($_.version)'."
        }
    }
}