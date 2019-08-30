
# Measure unfiltered command
$noFilterTiming = Measure-Command{
    Get-ChildItem -Path 'C:\' -Recurse | Where-Object Extension -eq ".exe" | Select-Object FullName | ConvertTo-Json
}
# Measure Filter first command 
$filterTiming = Measure-Command{
    Get-ChildItem -Path 'C:\' -Recurse -Filter *.exe | Select-Object FullName | ConvertTo-Json
}

# Output timing
"Filter first Duration: {0:mm} min {0:ss} sec" -f $filterTiming
"Format first Duration: {0:mm} min {0:ss} sec" -f $noFilterTiming
