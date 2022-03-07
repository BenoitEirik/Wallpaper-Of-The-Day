$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

if(!(Test-Path $RegKeyPath)) {
    Write-Host "Creating registry path $($RegKeyPath)."
    New-Item -Path $RegKeyPath -Force | Out-Null
}

New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value "1" -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImagePath" -Value "C:\WOTD\wotd.jpg" -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageUrl" -Value "C:\WOTD\wotd.jpg" -PropertyType STRING -Force | Out-Null
