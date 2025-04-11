#
# Integer value used by Enums

# Get the integer values of FileAttributes enum used by Get-ChildItem
[enum]::GetNames([System.IO.FileAttributes]) | % { $num = [System.IO.FileAttributes]::$_.value__; write-host "$num - $_" }

# Get the integer values of ExecutionPolicy used by Set-ExecutionPolicy
[enum]::GetNames([Microsoft.PowerShell.ExecutionPolicy]) | % { $num = [Microsoft.PowerShell.ExecutionPolicy]::$_.value__; write-host "$num - $_" }

# Get the integer values of ExecutionPolicyScope used by Set-ExecutionPolicy
[enum]::GetNames([Microsoft.PowerShell.ExecutionPolicyScope]) | % { $num = [Microsoft.PowerShell.ExecutionPolicyScope]::$_.value__; Write-Host "$num - $_" }

# Get the integer values of ConsoleColor used by Write-Host
[enum]::GetNames([ConsoleColor]) | % { $num = [ConsoleColor]::$_.value__; Write-Host "$num - $_" -ForegroundColor $num }

# Assign enum values to variables
$myColour = [ConsoleColor]::Blue

# Retrieve the variable value
$myColour

# Get the variables integer value
$myColour.value__