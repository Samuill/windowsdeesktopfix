# ���������� ������� ������� ���� �� �������
$currentDesktopFromRegistry = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").Desktop

# ���������� ����������� ���� � �������� �����
$defaultDesktopPath = "C:\Users\$env:USERNAME\Desktop"

# �������� ������� ���� � ������� yyyy-MM-dd
$currentDate = (Get-Date).ToString("yyyy-MM-dd")

# ���������, ������� �� ������� ���� � ��� ����������� Desktop
if ($currentDesktopFromRegistry -ieq $defaultDesktopPath) {
    Write-Output "������� ������� ���� � ����������� Desktop: $defaultDesktopPath"

    # �������� ������ ���� ����� �� ������� �����
    $folders = Get-ChildItem -Path $defaultDesktopPath -Directory

    # ���� �����, ��� ������� ���������� � ������� ����
    $targetFolder = $folders | Where-Object { $_.Name -like "$currentDate*" }

    # �������� ������ ���� ����� �� ������� �����
$folders = Get-ChildItem -Path $defaultDesktopPath -Directory

# ���� �����, ��� ������� ���������� � ������� ����
$targetFolders = $folders | Where-Object { $_.Name -like "$currentDate*" }

    if ($targetFolders) {
        # ��������� ��������� ����� �� ������� �������� � ������� ��������
        $latestFolder = $targetFolders | Sort-Object CreationTime -Descending | Select-Object -First 1

        # ���� ����� �������, ���������� � ��� ������� ����
        $newDesktopPath = $latestFolder.FullName
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $newDesktopPath
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $newDesktopPath

        # ������������� Explorer
        Stop-Process -Name explorer -Force
        Write-Output "������� ���� ������ �� �����: $newDesktopPath"
    } else {
        Write-Output "�����, ������������ � ������� ���� ($currentDate), �� ������� �� ������� �����."
    }

} else {
    Write-Output "������� ������� ���� ���������� �� ������������ Desktop. ������������ � ������������ ����."

    # ������������� ����������� Desktop ��� ������� ����
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $defaultDesktopPath
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $defaultDesktopPath

    # ������������� Explorer
    Stop-Process -Name explorer -Force
    Write-Output "������� ���� ��������� � ����������� �����: $defaultDesktopPath"
}
