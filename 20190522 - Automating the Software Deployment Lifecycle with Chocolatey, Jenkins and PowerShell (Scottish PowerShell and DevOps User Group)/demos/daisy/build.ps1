if (Test-Path -Path '*.nupkg') {
    Remove-Item -Path '*.nupkg'
}

choco pack
if (Test-Path -Path 'daisy*.nupkg') {
    choco push .\daisy.1.0.0.nupkg --source='http://localhost/chocolatey' --api-key='chocolateyrocks'
}

# Call the Jenkins job webhook
Invoke-WebRequest -Uri 'http://localhost:8080/buildByToken/build?job=Test%20Package%20and%20Push%20to%20Prod%20Repo&token=123456789ABCD' -UseBasicParsing