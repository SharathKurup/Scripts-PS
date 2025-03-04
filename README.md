# PS Scripts

This folder contains two PowerShell scripts for managing the installation of various applications using `winget`.

## Scripts

### `winget-install.ps1`

This script performs the following tasks:

1. **Run as Administrator**: Ensures the script is run with administrative privileges.
2. **Set UTF-8 Encoding**: Forces UTF-8 encoding to fix emoji display.
3. **Set Log File Paths**: Defines paths for log files:
   - `winget-install-log.txt`: General log file for the installation process.
   - `winget-successful.txt`: Log file for successfully installed applications.
   - `winget-failed.txt`: Log file for applications that failed to install.
4. **Ensure Log Files Exist**: Creates the log files if they do not already exist.
5. **List of Apps to Install**: Defines a list of applications to install or update.
6. **Install or Update Apps**: Loops through each app and attempts to install or update it using `winget`. Logs the results to the appropriate log files.
7. **Verify Installed Applications**: Verifies the installed applications and logs the results.
8. **Upgrade All Installed Apps**: Upgrades all installed applications to their latest versions.

### `failed_install.ps1`

This script reads the `winget-failed.txt` log file and attempts to reinstall any applications that previously failed to install.

### `robocopy` Commands

These commands are used for copying and verifying files between two directories.

#### `robocopy "H:\" "F:\" /E /ZB /XO /MT:16 /R:3 /W:3 /LOG:C:\copy_log.txt /TEE`

This command performs the following tasks:
1. **Source and Destination**: Copies files from `H:\` to `F:\`.
2. **Subdirectories**: Includes all subdirectories (`/E`).
3. **Restartable Mode**: Uses restartable mode (`/ZB`).
4. **Exclude Older Files**: Excludes older files (`/XO`).
5. **Multithreading**: Uses 16 threads for copying (`/MT:16`).
6. **Retry and Wait**: Retries 3 times and waits 3 seconds between retries (`/R:3 /W:3`).
7. **Logging**: Logs the output to `C:\copy_log.txt` and displays it in the console (`/LOG:C:\copy_log.txt /TEE`).

#### `robocopy "H:\" "F:\" /E /L /NJH /NJS /NP /FP > C:\verify_log.txt`

This command performs the following tasks:
1. **Source and Destination**: Lists files from `H:\` to `F:\`.
2. **Subdirectories**: Includes all subdirectories (`/E`).
3. **List Only**: Lists the files without copying (`/L`).
4. **No Job Header and Summary**: Omits job header and summary (`/NJH /NJS`).
5. **No Progress**: Omits progress information (`/NP`).
6. **Full Path**: Displays full path names of files (`/FP`).
7. **Logging**: Redirects the output to `C:\verify_log.txt`.

#### File Size Verification

These commands calculate the total size of files in the source and destination directories:

```powershell
(Get-ChildItem "H:\" -Recurse | Measure-Object -Property Length -Sum).Sum
(Get-ChildItem "F:\" -Recurse | Measure-Object -Property Length -Sum).Sum
```

## Usage

1. Open PowerShell as Administrator.
2. Run `winget-install.ps1` to install or update the list of applications.
3. If any applications fail to install, run `failed_install.ps1` to attempt to reinstall the failed applications.
4. Use the `robocopy` commands to copy and verify files between directories.

## Set Execution Policy

Before running the scripts, you may need to set the execution policy to allow running scripts. Use the following command:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Explanation of Policies:
- Restricted: No scripts allowed (default).
- AllSigned: Only signed scripts allowed.
- RemoteSigned: Locally created scripts run, remote scripts need a signature.
- Unrestricted: All scripts can run (⚠️ Not recommended for security reasons).