
function Start-DeathStar {
    Param (
        [string]
        $Target)
    # does not reformat the param block

if ($Target -eq "Alderaan") { Write-Verbose 'Targetting Alderaan'
            Write-Verbose "Help me Obi-Wan. You're my only hope."

        Enable-PlanetBlowerUpperGun -Target 'Alderaan'
}
else {
Write-Verbose 'Unknown target'
Disable-PlanetBlowerUpperGun }
}

