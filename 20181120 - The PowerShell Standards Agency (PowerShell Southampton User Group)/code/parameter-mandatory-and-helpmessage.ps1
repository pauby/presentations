

function Start-DeathStar {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, 
            HelpMessage = 'Planet to target')]
        [string]
        $Target
    )
}