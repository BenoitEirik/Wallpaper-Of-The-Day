$action = New-ScheduledTaskAction -Execute "powershell" -Argument "-ExecutionPolicy ByPass -File C:\WOTD\wotd.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WallpaperOfTheDay" -Description "Daily change wallpaper"
