#
# Assigning integer values to enum members

# Create enum
enum RebelBase { D_Qar; Dantooine; Hoth; Yavin_4 }

# Get the integer value of Hoth
[RebelBase]::Hoth.value__

# Alternative way to find the integer value of Hoth
[int][RebelBase]::Hoth

# Create enum with integer values
enum RebelBase { D_Qar; Dantooine = 18; Hoth; Yavin_4 = 981 }

# Get the integer values of each member of the enum 
[enum]::GetNames([RebelBase]) | % { "$([RebelBase]::$_.value__) - $_" }