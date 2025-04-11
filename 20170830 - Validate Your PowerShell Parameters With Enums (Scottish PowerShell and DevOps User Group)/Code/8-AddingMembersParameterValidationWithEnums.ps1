#
# Addind new Rebel Scum bases to our members list

enum RebelBase { D_Qar; Dantooine; Hoth; Yavin_4; Atollon; Scarif }

function Set-DeathStarTarget {
    Param (
        [Parameter(Mandatory)]
        [RebelBase]$Planet
    )

    # Deploy the planet blower-upper gun!
    Write-Host "`nTargetting $Planet to destory with our planet-blower-upper gun!`n" -ForegroundColor Green
}

function Invoke-PlanetInvasion {
    Param (
        [Parameter(Mandatory)]
        [RebelBase]$Planet
    )

    # Start the invasion of the rebel scum planets!
    Write-Host "`nLet's invade $Planet and destory the Rebel scum!`n" -ForegroundColor Green
}

function Set-FleetDestination {
    Param (
        [Parameter(Mandatory)]
        [RebelBase]$Planet
    )

    # Give the fleet orders to make their way to the planet
    Write-Host "`nSend the fleet to $Planet. Prepare to make the jump to lightspeed!`n" -ForegroundColor Green
}

Set-DeathStarTarget -Planet "Hoth"
Invoke-PlanetInvasion -Planet "Dantooine"
Set-FleetDestination -Planet "D_Qar"

# Still cannot target Scarif
Set-DeathStarTarget -Planet "Scarif"
Invoke-PlanetInvasion -Planet "Scarif"
Set-FleetDestination -Planet "Scarif"