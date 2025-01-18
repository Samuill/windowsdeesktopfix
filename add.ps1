# �������� ������� ���� �������� �����
$currentDesktopPath = [Environment]::GetFolderPath("Desktop")

# ���������� ����������� ���� �������� �����
$defaultDesktopPath = "C:\Users\$env:USERNAME\Desktop"

# ���������, �������� �� ������� ������� ���� �����������
if ($currentDesktopPath -eq $defaultDesktopPath) {
    # ���� ������� ���� �����������, ������ ����� �����
    $newFolderName = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $newFolderPath = Join-Path $currentDesktopPath $newFolderName

    # ������ ����� �����
    New-Item -ItemType Directory -Path $newFolderPath

    # ������������� ����� ����� ��� ������� ����
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value $newFolderPath
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "Desktop" -Value $newFolderPath

    # ������������� Explorer
    Stop-Process -Name explorer -Force

    Write-Output "������� ���� ������ �� ����� �����: $newFolderPath"
} else {
    # ���� ������� ���� �� �����������, ��������� ����������
    Write-Output "������� ������� ���� �� �������� �����������. �������� ��������."
}
