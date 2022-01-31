# Arguments manager
$inst = $args[0]
$localeCode = $args[1]
if ($inst -eq "install") {
  # Set default language code
  if ($localeCode -eq "") {
    $localeCode = "fr-FR"
  }

  $action = New-ScheduledTaskAction -Execute "powershell" -Argument "-WindowStyle Hidden -ExecutionPolicy ByPass -File C:\WOTD\wotd.ps1 $($localeCode)"
  $trigger = New-ScheduledTaskTrigger -AtLogon
  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WallpaperOfTheDay" -Description "Daily change wallpaper"
  Exit
}
else {
  $localeCode = $args[0]
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
$json = $WebClient.DownloadString("https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$($localeCode)")
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
