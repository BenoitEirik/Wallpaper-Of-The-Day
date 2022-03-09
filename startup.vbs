Dim objShell,objFSO,objFile

Set objShell=CreateObject("WScript.Shell")
Set objFSO=CreateObject("Scripting.FileSystemObject")

'Get localeCode argument
localeCode = Wscript.Arguments(0)
dest = Wscript.Arguments(1)

'Path for the PowerShell Script
 strPath= dest & "\wotd.ps1"

'Verify if file exists
If objFSO.FileExists(strPath) Then
   'Return short path name
   set objFile=objFSO.GetFile(strPath)
   strCMD="powershell -ExecutionPolicy bypass -nologo -command " & Chr(34) & "&{" &_
    objFile.ShortPath & " -Locale " & localeCode & " -Dest " & dest & "}" & Chr(34)

  'Use 0 to hide window
   objShell.Run strCMD,0

Else

  'Display error message
   WScript.Echo "Wallpaper Of The Day: " & strPath & "not found."
   WScript.Quit

End If