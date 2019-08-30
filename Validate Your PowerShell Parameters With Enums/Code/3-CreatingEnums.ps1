#
# Creating your own enums

# Pre v5 way still works in v5
Add-Type -TypeDefinition @"
        public enum RebelBase
        {
            D_Qar,
            Dantooine,
            Hoth,
            Yavin_4
        }
"@
$base = [RebelBase]::Hoth
$base

# v5 onwards way to create enums
enum RebelBase { 
    D_Qar
    Dantooine
    Hoth
    Yavin_4
}

$base = [RebelBase]::Yavin_4
$base

# You must use semicolons to separate members when creation is done on one line
enum RebelBase { D_Qar; Dantooine; Hoth; Yavin_4 }

$base = [RebelBase]::D_Qar
$base
