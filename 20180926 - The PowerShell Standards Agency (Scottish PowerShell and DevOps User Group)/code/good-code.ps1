# Help removed for brevity
function Start-DeathStar {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $Target
    )
    if ($Target -eq 'Alderaan') {
        Write-Verbose 'Targetting Alderaan'
        Enable-PlanetBlowerUpperGun
    }
    else {
        Write-Verbose 'Unknown target'
        Disable-PlanetBlowerUpperGun
    }
}
# Help removed for brevity
function Enable-PlanetBlowerUpperGun {
    [CmdletBinding()]
    Param ()

    Write-Verbose 'Enabled gun.'
}
# Help removed for brevity
function Disable-PlanetBlowerUpperGun {
    [CmdletBinding()]
    Param ()

    Write-Verbose 'Disabled gun.'
}

