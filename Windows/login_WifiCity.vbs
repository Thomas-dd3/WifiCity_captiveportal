Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Windows\System32\login_WifiCity.bat" & Chr(34), 0
Set WinScriptHost = Nothing