
function Start-DeathStar {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $Target
    )

    if ($Target -eq 'Alderaan') {
        Write-Verbose 'Targetting Alderaan'
        Write-Verbose "Help me Obi-Wan. You're my only hope."
        Write-Debug 'Enabling gun'
        Enable-PlanetBlowerUpperGun
    }
    else {
        Write-Verbose 'Unknown target'
        Write-Debug 'Disabling gun'
        Disable-PlanetBlowerUpperGun
    }
}

function Enable-PlanetBlowerUpperGun {
    [CmdletBinding()]
    Param ()

    Write-Verbose 'Enabled gun.'
}

function Disable-PlanetBlowerUpperGun {
    [CmdletBinding()]
    Param ()

    Write-Verbose 'Disabled gun.'
}
break

Start-DeathStar -Target 'Alderaan'
Start-DeathStar -Target 'Alderaan' -Verbose
Start-DeathStar -Target 'Alderaan' -Debug
Start-DeathStar -Target 'Alderaan' -Verbose -Debug

