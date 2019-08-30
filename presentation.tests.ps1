Describe "Testing pre-requisites for presentations" {

    Context 'Required Module - Pester' {
        It 'should pass if Pester is installed' {
            [bool](Get-Module -Name Pester -ListAvailable) | Should -Be $true
        }

        It 'should pass if the Pester version is >= 4.3.1' {
            (Get-Module -Name Pester -ListAvailable | Select-Object -First 1).Version -ge [Version]"4.3.1" | Should -Be $true
        }
    }

    Context 'VS Code Configuration' {
        # TODO Check VS Code theme is set to something bright for ease of viewing
    }

    Context 'Logitech Presenter' {
        It 'should pass if the Logitech Presentation software is running' {
            { Get-Process -Name 'LogiPresentationUI' -ErrorAction Stop } | Should not throw
        }
    }
}