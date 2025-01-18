# Определяем текущий рабочий стол из реестра
$currentDesktopFromRegistry = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").Desktop

# Определяем стандартный путь к рабочему столу
$defaultDesktopPath = "C:\Users\$env:USERNAME\Desktop"

# Получаем текущую дату в формате yyyy-MM-dd
$currentDate = (Get-Date).ToString("yyyy-MM-dd")

# Проверяем, текущий ли рабочий стол — это стандартный Desktop
if ($currentDesktopFromRegistry -ieq $defaultDesktopPath) {
    Write-Output "Текущий рабочий стол — стандартный Desktop: $defaultDesktopPath"

    # Получаем список всех папок на рабочем столе
    $folders = Get-ChildItem -Path $defaultDesktopPath -Directory

    # Ищем папку, имя которой начинается с текущей даты
    $targetFolder = $folders | Where-Object { $_.Name -like "$currentDate*" }

    # Получаем список всех папок на рабочем столе
$folders = Get-ChildItem -Path $defaultDesktopPath -Directory

# Ищем папки, имя которых начинается с текущей даты
$targetFolders = $folders | Where-Object { $_.Name -like "$currentDate*" }

    if ($targetFolders) {
        # Сортируем найденные папки по времени создания в порядке убывания
        $latestFolder = $targetFolders | Sort-Object CreationTime -Descending | Select-Object -First 1

        # Если папка найдена, используем её как рабочий стол
        $newDesktopPath = $latestFolder.FullName
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $newDesktopPath
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $newDesktopPath

        # Перезапускаем Explorer
        Stop-Process -Name explorer -Force
        Write-Output "Рабочий стол изменён на папку: $newDesktopPath"
    } else {
        Write-Output "Папка, начинающаяся с текущей даты ($currentDate), не найдена на рабочем столе."
    }

} else {
    Write-Output "Текущий рабочий стол отличается от стандартного Desktop. Возвращаемся к стандартному пути."

    # Устанавливаем стандартный Desktop как рабочий стол
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $defaultDesktopPath
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $defaultDesktopPath

    # Перезапускаем Explorer
    Stop-Process -Name explorer -Force
    Write-Output "Рабочий стол возвращён в стандартное место: $defaultDesktopPath"
}
