#
# Traditional parameter validation

function Set-DeathStarTarget {
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( "D_Qar", "Dantooine", "Hoth", "Yavin_4")]
        [string]$Planet
    )

    # Deploy the planet with our blower-upper gun!
    Write-Host "`nTargetting $Planet to destory with our planet-blower-upper gun!`n" -ForegroundColor Green
}

# Target Hoth
Set-DeathStarTarget -Planet "Hoth"

# Target Scarif - this isn't on the list of rebel bases so will result in an error
Set-DeathStarTarget -Planet "Scarif"

# Add another function with the same validation set
function Invoke-PlanetInvasion {
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( "D_Qar", "Dantooine", "Hoth", "Yavin_4")]
        [string]$Planet
    )

    # Start the invasion of the rebel scum planets!
    Write-Host "`nLet's invade $Planet and destroy the Rebel scum!`n" -ForegroundColor Green
}

# Start the invasion of Hoth
Invoke-PlanetInvasion -Planet "Dantooine"

# Start the invasion of Scarif
Invoke-PlanetInvasion -Planet "Scarif"

# Send the fleet!
function Set-FleetDestination {
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( "D_Qar", "Dantooine", "Hoth", "Yavin_4")]
        [string]$Planet
    )

    # Give the fleet orders to make their way to the planet
    Write-Host "`nSend the fleet to $Planet. Prepare to make the jump to lightspeed!`n" -ForegroundColor Green
}

# Send the fleet to D_Qar
Set-FleetDestination -Planet "D_Qar"

# Now we want to add Scarif to the list of potential targets ...