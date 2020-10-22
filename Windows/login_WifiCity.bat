:: Login to WifiCity captive portale

@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

:: CALL :login_wificity CFB_001 , df23JdAB
CALL :login_wificity LOGIN , PASSWORD

ENDLOCAL
EXIT /B %ERRORLEVEL%


:login_wificity
    set authserver=http://10.254.0.254:1000
    set gen204="http://www.google.com/gen_204"
    set username=%~1
    set password=%~2

    set /A count=1

    FOR /F "tokens=*" %%g IN ('curl -si %gen204%') do (
        if !count! == 1 set gen204_status=%%g
        if !count! == 2 set gen204_location=%%g

        set /A count=!count!+1
    )

    set status=%gen204_status:~9,3%

    if %status% NEQ 204 (
        set magic=%gen204_location:~43,16%

        curl -so NUL "!authserver!/fgtauth?!magic!"
        curl -so NUL "!authserver!" --data "magic=!magic!&username=!username!&password=!password!"

    )

EXIT /B 0