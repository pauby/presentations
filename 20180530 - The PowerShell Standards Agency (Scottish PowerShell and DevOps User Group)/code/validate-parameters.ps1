
function Start-DeathStar {
    Param (
        [ValidateCount(1, 10)]
        [string[]]$Target
    )
}


function Start-DeathStar {
    Param (
        [ValidateLength(3, 20)]
        [string[]]$Target
    )
}


function Start-DeathStar {
    Param (
        [ValidatePattern("FO\d{5}")]
        [string[]]$LoginID
    )
}


function Start-DeathStar {
    Param (
        [ValidateScript( {
            Test-Planet -Planet $_ })]
        [string[]]$Target
    )
}


function Start-DeathStar {
    Param (
        [ValidateRange(1, 3)]
        [int]$GunsToFire
    )
}


function Start-DeathStar {
    Param (
        [ValidateSet(
            'Tatooine', 'Alderaan')]
        [string]$Target
    )
}