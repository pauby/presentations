
function Invoke-PesterBreaker
{
    $true
}

Describe 'We are going to break Pester' {

    It 'should break Pester' {
        Invoke-PesterBreaker | Should -Be $true
    }
}

