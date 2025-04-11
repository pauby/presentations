# https://pau.by/helphelp

function Start-DeathStar {
    <#
    .SYNOPSIS
        This starts the Death Star.
    .DESCRIPTION
        Starts the Death Star and prepares it for firing the Planet Blower Upper
        gun.
    .PARAMETER Target
        This is the target for the guns.
    .EXAMPLE
        Start-DeathStar

        Starts the Death Star and targets Alderaan.
    .EXAMPLE
        Start-DeathStar -Target 'Dantooine'

        Starts the Death Star and targets the planet Dantooine.
    .NOTES
        Written by The PowerShell Standards Agency for, and on behalf of, The
        First Order.
    .LINK
        Enable-PlanetBlowerUpperGun
    .LINK
        Disable-PlanetBlowerUpperGun
    .LINK
        https://github.com/pauby/presentations/tree/master/The%20PowerShell%20Standards%20Agency/docs/Start-DeathStar.md
    #>
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