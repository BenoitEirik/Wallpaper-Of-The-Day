# Arguments manager
param ($Setup, $Locale, $Dest)

$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

############ Installation ############

if ($Setup -eq "install" -Or $Setup -eq "uninstall") {
  if ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") -eq $false) {
    Write-Host "[Warning] Need administrator rights!"
    Exit
  }
}

if ($Setup -eq "install" ) {
  # Set default language code
  if (!$Locale) {
    $Locale = "fr-FR"
  }

  # Set default location
  if (!$Dest)
  {
    $DriveLetter = (Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name -First 1)
    $Dest = $DriveLetter + ":\Program Files\WOTD"
    mkdir "$($DriveLetter):\Program Files\WOTD"
  }
  
  # Copy file to location
  Copy-Item "$($PSScriptRoot)\wotd.ps1" -Destination "$($Dest)"
  Copy-Item "$($PSScriptRoot)\startup.vbs" -Destination "$($Dest)"
  Copy-Item "$($PSScriptRoot)\README.md" -Destination "$($Dest)"

  # Set new task scheduler
  $action = New-ScheduledTaskAction -Execute "wscript" -Argument "//nologo `"$($Dest)\startup.vbs`" $($Locale) `"`"`"$($Dest)`"`"`""
  $trigger = New-ScheduledTaskTrigger -AtLogon
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WallpaperOfTheDay" -Description "Daily change wallpaper" -Settings $settings

  # Set registry keys for lockscreen wallpaper
  if(!(Test-Path $RegKeyPath)) {
    New-Item -Path $RegKeyPath -Force
  }
}

if ($Setup -eq "uninstall" ) {
  if ((Get-Location | Select-Object -ExpandProperty Path) -eq $PSScriptRoot) {
    Write-Host "[Warning] Make sure you are not in the folder where wotd.ps1 is"
    Exit
  }

  Remove-Item -Path $RegKeyPath
  Remove-Item $PSScriptRoot -Force -Recurse
  Exit
}


############ Set wallpaper ############

# Check internet connection for 5 minutes by step of 30 seconds
For ($i = 0; $i -lt 10; $i++) {
  if (Test-Connection 1.1.1.1 –Count 1 –Quiet) {
    break
  }
  elseif ($i -eq 9) {
    Exit
  }
  else {
    Start-Sleep -s 30
  }
}

# Downloading image
try {
  $WebClient = New-Object System.Net.WebClient
  $json = $WebClient.DownloadString("https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$($Locale)")
  $JsonObject = $json | ConvertFrom-Json
  $WebClient.DownloadFile("https://bing.com" + $JsonObject.images.url, $Dest + "\wotd.jpg")
} 
catch [System.Net.WebException],[System.IO.IOException],[System.Net.ArgumentNullException] {
  Exit
}


# Wallpaper setting class
$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

# Set desktop wallpaper
Start-Sleep -s 3 # To prevent black screen after downloading image
[Wallpaper]::SetWallpaper("$($Dest)\wotd.jpg")

# Set lockscreen wallpaper
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImagePath" -Value "$($Dest)\wotd.jpg" -PropertyType STRING -Force
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageUrl" -Value "$($Dest)\wotd.jpg" -PropertyType STRING -Force
