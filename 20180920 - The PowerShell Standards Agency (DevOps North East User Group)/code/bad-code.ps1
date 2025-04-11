
function Start_DeathStar {
    Param ([string]$param1)
if(!$param1){
Write-host "You didn't provide a parameter"; Return}
if ($param1 -eq "Alderaan") 
{       
    TurnON -param1 'Alderaan'
} else {
    turnOFF }
}

function TurnON{Param ()
    $true
}

function turnOFF{
    #this is False
    $false}