:: Made by Thomas with <3

@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    :: To stay in the execution folder
    @cd /d "%~dp0"


:: Creating the menu
CALL :menu
EXIT /B 0

:menu
echo Menu:
echo 1/ Install
echo 2/ Remove
echo 3/ Exit
echo.
set action=0
set /P action="Select one action from the previous menu ? (Write 1, 2 or 3 and press enter) "

if %action% EQU 1 (
    echo Please enter your credential
    set /P wificity_login="Login = "
    set /P wificity_password="Password = "
    CALL :data >C:\Windows\System32\login_WifiCity.bat
    echo.
    if exist C:\Windows\System32\login_WifiCity.bat (
        echo Automatic login script successfully written
    ) else (
        echo An error occured, the script was not created.
        echo Please check that you execute this file in Administrator mode.
    )
    :: SCHTASKS /Create /TN WifiCityAutomaticConnection /SC ONEVENT /EC Microsoft-Windows-NetworkProfile/Operational /MO "*[System[(EventID=10000)]] and *[EventData[(Data[@Name='Name']='WifiCity')]]" /TR "C:\Windows\System32\login_WifiCity.bat"
    SCHTASKS /CREATE /TN WifiCityAutomaticConnection /XML WifiCityAutomaticConnection.xml
    echo.
    GOTO :menu
)

if %action% EQU 2 (
    SCHTASKS /DELETE /TN WifiCityAutomaticConnection /F
    del C:\Windows\System32\login_WifiCity.bat
    if exist C:\Windows\System32\login_WifiCity.bat (
        echo An error occured, the script was not deleted.
        echo Please check that you execute this file in Administrator mode.
    ) else (
        echo Automatic login script successfully removed
    )
    echo.
    GOTO :menu
)

if %action% EQU 3 (
    EXIT /B 0
)

echo.
echo Please enter a correct value.
echo.
GOTO :menu
EXIT /B 0

:data
echo: :: Login to WifiCity captive portale
echo:
echo: @echo off
echo:
echo: SETLOCAL ENABLEDELAYEDEXPANSION
echo:
echo: ::CALL :login_wificity login , password
echo:
echo: CALL :login_wificity %wificity_login% , %wificity_password%
echo:
echo: ENDLOCAL
echo: EXIT /B %%ERRORLEVEL%%
echo:
echo: :login_wificity
echo:     set authserver=http://10.254.0.254:1000
echo:     set gen204="http://www.google.com/gen_204"
echo:     set username=%%~1
echo:     set password=%%~2
echo:
echo:     set /A count=1
echo: 
echo:     FOR /F "tokens=*" %%%%g IN ('curl -si %%gen204%%') do (
echo:         if !count! == 1 set gen204_status=%%%%g
echo:         if !count! == 2 set gen204_location=%%%%g
echo:
echo:         set /A count=!count!+1
echo:     )
echo:
echo:     set status=%%gen204_status:~9,3%%
echo: 
echo:     if %%status%% NEQ 204 (
echo:       set magic=%%gen204_location:~43,16%%
echo:
echo:         curl -so NUL "!authserver!/fgtauth?!magic!"
echo:         curl -so NUL "!authserver!" --data "magic=!magic!&username=!username!&password=!password!"
echo:
echo:     )
echo:
echo: EXIT /B 0
EXIT /B 0

