<#
.NOTES
    Written by Paul Broadwith (paul@pauby.com) October 2018
#>

#Requires -Modules Pester
[CmdletBinding()]
Param (
    [string[]]
    $Name,

    [string]
    $Source,

    [string]
    $Path
)

Describe "Testing Chocolatey Package $(Split-Path -Path $Path -Leaf)" {

    $tempPath = New-Item -Path (Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid) -ItemType Directory -ErrorAction Stop

    It "should be a valid .nupkg file format" {
        $unzipCmd = "7z x -y -bd -bb0 -o$($tempPath.ToString()) $Path"
        Invoke-Expression -Command $unzipCmd

        $LASTEXITCODE | Should -Be 0
    }

    # Clear out the unneeded files and folders from the package extraction
    Remove-Item -Path '[Content_Types].xml' -Force
    'package', '_rels' | ForEach-Object {
        Remove-Item -Path (Join-Path -Path $tempPath -ChildPath $_) -Recurse -Force
    }

    $nuspecFile = Get-ChildItem -Path (Join-Path -Path $tempPath -ChildPath '*.nuspec')
    It "should contain one .nuspec file" {
        @($nuspecFile).Count | Should -Be 1
    }

    It "should have a valid .nuspec file" {
        { [xml](Get-Content -Path $nuspecFile) } | Should -Not -Throw
    }

    Context "Testing package $Name" {
        #$password = ConvertTo-SecureString 'vagrant' -AsPlainText -Force
        #$creds = New-Object System.Management.Automation.PSCredential ("vagrant", $password)
        #$session = New-PSSession -ComputerName 'chocotest' -Credential $creds

        it 'should install package without error' {
            # { Invoke-Command -Session $session -ScriptBlock {
            #     choco install $Using:Name -y --limit-output --no-progress
            #     if ($LASTEXITCODE -ne 0) {
            #         throw "Package install failed"
            #     }
            # } } | Should -Not -Throw
            choco install $Name -y -s "'$tempPath;$Source'"
            $LASTEXITCODE | Should Be 0
            # $true | Should Be $true
        }

        it 'should uninstall without error' {
            # { Invoke-Command -Session $session -ScriptBlock {
            #     choco.exe uninstall $Using:Name -y --limit-output --no-progress
            #     if ($LASTEXITCODE -ne 0) {
            #         throw "Package uninstall failed"
            #     }
            # } } | Should -Not -Throw
            choco uninstall $Name -y
            $LASTEXITCODE | Should Be 0
            # $true | Should Be $true
        }
    } #context
}# describe