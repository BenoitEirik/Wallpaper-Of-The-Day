For ($i=0; $i -lt 10; $i++) {
    if (!(Test-Connection 1.1.1.1 –Count 1 –Quiet)) {
        Start-Sleep -s 30s
    }
    elseif ($i=9) {
        Exit
    }
    else {
        break
    }
}

$WebClient = New-Object System.Net.WebClient
$json = $WebClient.DownloadString("https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=fr-FR")

$url = $json | ConvertFrom-Json
$WebClient.DownloadFile("https://bing.com" + $url.images.url,"C:\WOTD\wotd.jpg")

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

[Wallpaper]::SetWallpaper("C:\WOTD\wotd.jpg")
