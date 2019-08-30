#
# Common Enums used in PowerShell

# Look for common data types in cmdlet help
Get-Help Get-ChildItem 

# The parameter takes a string value
Get-Help Get-ChildItem -Parameter Filter

# On the surface this parameter does not take a common data type
Get-Help Get-ChildItem -Parameter Attributes

# Check what data type this is
[System.IO.FileAttributes]

# Find out the values this enum has 
[enum]::GetNames([System.IO.FileAttributes])

# Compare these values to the help for the cmdlet
Get-Help Get-ChildItem

# Have a look at this cmdlet too
Get-Help Set-ExecutionPolicy

# ExecutionPolicy parameter looks like it could be an enum due to the multiple data types it takes
Get-Help Set-ExecutionPolicy -Parameter ExecutionPolicy

# The scope parameter also looks like it could be an enum
Get-Help Set-ExecutionPolicy -Parameter Scope

# Get the data type of each parameter
[Microsoft.PowerShell.ExecutionPolicy]

[Microsoft.PowerShell.ExecutionPolicyScope]

# Get the value of the ExecutionPolicy parameter enum and compre it to the cmdlet help
[enum]::GetNames([Microsoft.PowerShell.ExecutionPolicy])

Get-Help Set-ExecutionPolicy

# Get the values of the ExecutionPolicyScope parameter enum and compare it to the cmdlet help
[enum]::GetNames([Microsoft.PowerShell.ExecutionPolicyScope])

Get-Help Set-ExecutionPolicy

# Set-Service uses one too
Get-Help Set-Service -Parameter StartupType

[enum]::GetNames([System.ServiceProcess.ServiceStartMode])

# Write-Host uses colours
[ConsoleColor]

[enum]::GetNames([ConsoleColor])