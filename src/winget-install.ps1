# Run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Force UTF-8 encoding to fix emoji display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Set log file paths
$logFile = "$env:USERPROFILE\Desktop\winget-install-log.txt"
$successLog = "$env:USERPROFILE\Desktop\winget-successful.txt"
$failedLog = "$env:USERPROFILE\Desktop\winget-failed.txt"

# Ensure log files exist
New-Item -Path $logFile -ItemType File -Force | Out-Null
New-Item -Path $successLog -ItemType File -Force | Out-Null
New-Item -Path $failedLog -ItemType File -Force | Out-Null

Write-Output "Starting installation... Logs will be saved to $logFile"
Write-Output "------------------------------------" | Out-File -Append $logFile

# List of apps to install
$apps = @(
    "Google.Chrome", 
    "MartiCliment.UniGetUI",  
    "Notepad++.Notepad++",  
    "OpenJS.NodeJS.LTS",  
    "Microsoft.VisualStudioCode",  
    "JetBrains.WebStorm",  
    "MongoDB.Server",  
    "MongoDB.Compass.Community",  
    "Git.Git",  
    "GitHub.GitHubDesktop",  
    "Postman.Postman",  
    "Httpie.Httpie",  
    "Microsoft.PowerToys", 
    "CPUID.HWMonitor", 
    "VideoLAN.VLC", 
    "Notion.Notion", 
    "Notion.NotionCalendar", 
    "Obsidian.Obsidian", 
    "Bitwarden.Bitwarden"
)

# Loop through each app and attempt installation
foreach ($app in $apps) {
    Write-Output "Installing or updating: $app" | Tee-Object -FilePath $logFile -Append
    $installResult = winget install --id=$app --silent --accept-source-agreements --accept-package-agreements 2>&1

    if ($installResult -match "Successfully installed|already installed|was installed successfully") {
        Write-Output "✅ Success: $app" | Tee-Object -FilePath $successLog -Append
    } else {
        Write-Output "❌ Failed: $app" | Tee-Object -FilePath $failedLog -Append
    }

    # Append full output to the log file
    $installResult | Out-File -Append $logFile
}

# Verify installed applications
Write-Output "Verifying installed applications..." | Tee-Object -FilePath $logFile -Append
$escapedApps = $apps -replace '\+', '[+]'
$installedApps = winget list | Select-String -Pattern ($escapedApps -join "|")

# Save successful installations
$installedApps | Out-File -Append $successLog
Write-Output "Installation verification completed. Check logs for details."

# Upgrade all installed apps
Write-Output "Upgrading all installed apps..." | Tee-Object -FilePath $logFile -Append
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements | Out-File -Append $logFile

Write-Output "✅ All installations and updates completed! Check logs for details."
