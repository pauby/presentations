function New-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateCount(250, 1000)]
        [string[]]
        $FullName
    )
}

function Add-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateLength(1,30)]
        [string[]]
        $FullName
    )
}

function Add-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidatePattern(250, 1000)]
        [string[]]
        $DOB
    )
}

function Add-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateScript( { Test-ID -ID $_ } )]
        [string[]]
        $ID
    )
}

function New-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateRange(18, 200)]
        [int32]
        $Age
    )
}

function New-DeathStarCrew {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateSet('Captain', 'Lieutenant')]
        [string]
        $Rank
    )
}