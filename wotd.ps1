# Arguments manager
param ($Setup, $Locale, $Dest)



############ Installation ############

if ($Setup -eq "install" ) {
  # Set default language code
  if (!$Locale) {
    $Locale = "fr-FR"
  }

  # Set default location
  if (!$Dest)
  {
    $DriveLetter = (Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name -First 1)
    $Dest = $DriveLetter + ":\WOTD"
    mkdir "$($DriveLetter)\Program Files\WOTD"
  }
  
  # Copy file to location
  Copy-Item "$($PSScriptRoot)\wotd.ps1" -Destination "$($Dest)"
  Copy-Item "$($PSScriptRoot)\startup.vbs" -Destination "$($Dest)"
  Copy-Item "$($PSScriptRoot)\README.md" -Destination "$($Dest)"

  # Set new task scheduler
  $action = New-ScheduledTaskAction -Execute "wscript" -Argument "//nologo `"$($Dest)\startup.vbs`" $($Locale)"
  $trigger = New-ScheduledTaskTrigger -AtLogon
  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WallpaperOfTheDay" -Description "Daily change wallpaper"
  Exit
}



############ Set wallpaper ############

# Set default language code
if (!$Locale) {
  $Locale = "fr-FR"
}

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
$WebClient = New-Object System.Net.WebClient
$json = $WebClient.DownloadString("https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$($Locale)")
$JsonObject = $json | ConvertFrom-Json
$WebClient.DownloadFile("https://bing.com" + $JsonObject.images.url, "C:\WOTD\wotd.jpg")

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

# Set the wallpaper
[Wallpaper]::SetWallpaper("C:\WOTD\wotd.jpg")
