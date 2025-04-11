
function Start-DeathStar {

    Param (
        [string]
        $Target = 'Alderaan'
    )
    # does not reformat the param block

    if ($Target -eq "Alderaan") {
        Write-Verbose 'Targetting Alderaan'
        Write-Verbose "Help me Obi-Wan. You're my only hope."

        Enable-PlanetBlowerUpperGun -Target 'Alderaan'
    }
    else {
        Write-Verbose 'Unknown target'
        Disable-PlanetBlowerUpperGun
    }
}
break

# Shows basic help about the function
Get-Help Start-DeathStar

# Shows the examples for the function
Get-Help Start-DeathStar -Examples

# SHows the online help for the function
Get-Help Start-DeathStar -Online