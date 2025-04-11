#Requires -Modules Pester
[CmdletBinding()]
Param (
    [string]
    $Name,

    [string]
    $Path
)

Describe "Testing Chocolatey Package $Name" {

    # create a temporary folder
    $tempPath = New-Item -Path (Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).Guid) `
        -ItemType Directory -ErrorAction Stop

    # Chocolatey packages are special ZIP files so check its extracts correctly
    It "should be a valid .nupkg file format" {
        $unzipCmd = "7z x -y -bd -bb0 -o$($tempPath.ToString()) '$Path'"
        Invoke-Expression -Command $unzipCmd

        $LASTEXITCODE | Should -Be 0
    }

    # Clear out the unneeded files and folders from the package extraction
    Remove-Item -Path '[Content_Types].xml' -Force
    'package', '_rels' | ForEach-Object {
        Remove-Item -Path (Join-Path -Path $tempPath -ChildPath $_) -Recurse -Force
    }

    # Test there is only one nuspec file in the package
    $nuspecFile = Get-ChildItem -Path (Join-Path -Path $tempPath -ChildPath '*.nuspec')
    It "should contain one .nuspec file" {
        @($nuspecFile).Count | Should -Be 1
    }

    # a nupsec file is simply XML so test it is correct
    It "should have a valid .nuspec file" {
        { [xml](Get-Content -Path $nuspecFile) } | Should -Not -Throw
    }

    Context "Test package .nuspec fields" {
        $data = [xml](Get-Content -Path $nuspecFile)
        $data = $data.package.metadata

        It "should have an id that <= 25 characters" {
            ($data.id).Length | Should -BeLessOrEqual 25
        }

        if (-not [string]::IsNullOrEmpty($data.projectUrl)) {
            It "should have a valid projectUrl" {
                (Invoke-WebRequest -Uri $data.projectUrl -UseBasicParsing).StatusCode | Should -Be 200
            }
        } 
    }

    # Install and uninstall the package to ensure it works correctly
    Context "Testing package $Name" {
        $password = ConvertTo-SecureString 'vagrant' -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential ("chocotest\vagrant", $password)
        $session = New-PSSession -ComputerName 'chocotest' -Credential $creds
        Copy-Item -Path $Path -Destination 'C:\Windows\Temp' -ToSession $session

        it 'should install package without error' {
            { Invoke-Command -Session $session -ScriptBlock {
                choco install $Using:Name --source=c:\windows\temp
                if ($LASTEXITCODE -ne 0) {
                    throw "Package install failed"
                }
            } } | Should -Not -Throw
        }

        it 'should uninstall without error' {
            { Invoke-Command -Session $session -ScriptBlock {
                choco.exe uninstall $Using:Name --source=c:\windows\temp
                if ($LASTEXITCODE -ne 0) {
                    throw "Package uninstall failed"
                }
            } } | Should -Not -Throw
        }
    } #context
}# describe