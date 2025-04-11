
# Testing presentations requirements & windows settings

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
        It "Should have VS Code running" {
            (Get-Process 'Code' -ErrorAction SilentlyContinue).Count | Should Not BeNullorEmpty
        }
        # TODO Check VS Code theme is set to something bright for ease of viewing
    }
    Context 'PowerPoint Presentation' {
        It "Should have PowerPoint Open" {
            (Get-Process POWERPNT -ErrorAction SilentlyContinue).Count | Should Not BeNullOrEmpty
        }
        It "Should have One PowerPoint Open" {
            (Get-Process POWERPNT -ErrorAction SilentlyContinue).Count | Should Be 1
        }
        It "Should have the correct PowerPoint Presentation Open" {
            (Get-Process POWERPNT -ErrorAction SilentlyContinue).MainWindowTitle| Should Be 'PowerShell Standards Agency.pptx - PowerPoint'
        }
    }
    Context 'Messenger apps' {
        It "Telegram should be closed" {
            (Get-Process Telegram -ErrorAction SilentlyContinue).Count | Should Be 0
        }
        It "Skype should be closed" {
            (Get-Process Skype* -ErrorAction SilentlyContinue).Count | Should BE 0
        }
    }

    Context 'Logitech Presenter' {
        # TODO Check this is installed and running
    }
}