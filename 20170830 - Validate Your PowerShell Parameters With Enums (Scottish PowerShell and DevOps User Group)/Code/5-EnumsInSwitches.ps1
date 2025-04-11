#
# How to use enums with switch statements

enum RebelBase { D_Qar; Dantooine; Hoth; Yavin_4; Atollon }

$planet = [RebelBase]::Atollon

switch ($planet) {
    "D_Qar" {
        $base = "D'Qar (it's covered in jungle)"
        continue
    }

    "Dantooine" {
        $base = "Dantooine (rural forested planet)"
        continue
    }

    "Hoth" {
        $base = "Hoth (it's cold)"
        continue
    }

    "Yavin_4" {
        $base = "Yavin 4 (it's a moon)"
        continue
    }

    "Atollon" {
        $base = "Atollon (it's a desert planet)"
        continue
    }
}

Write-Host "`nThe rebel scum have a base on $base`n" -ForegroundColor Green