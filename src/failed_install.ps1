Get-Content "$env:USERPROFILE\Desktop\winget-failed.txt" | ForEach-Object { winget install --id=$_ --silent --accept-source-agreements --accept-package-agreements }
