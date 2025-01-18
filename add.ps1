# Получаем текущий путь рабочего стола
$currentDesktopPath = [Environment]::GetFolderPath("Desktop")

# Определяем стандартный путь рабочего стола
$defaultDesktopPath = "C:\Users\$env:USERNAME\Desktop"

# Проверяем, является ли текущий рабочий стол стандартным
if ($currentDesktopPath -eq $defaultDesktopPath) {
    # Если рабочий стол стандартный, создаём новую папку
    $newFolderName = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $newFolderPath = Join-Path $currentDesktopPath $newFolderName

    # Создаём новую папку
    New-Item -ItemType Directory -Path $newFolderPath

    # Устанавливаем новую папку как рабочий стол
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $newFolderPath
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $newFolderPath

    # Перезапускаем Explorer
    Stop-Process -Name explorer -Force

    Write-Output "Рабочий стол изменён на новую папку: $newFolderPath"
} else {
    # Если рабочий стол не стандартный, завершаем выполнение
    Write-Output "Текущий рабочий стол не является стандартным. Операция отменена."
}
