# Windows version

## How to use 

Follow the explaination at the repository root readme.

> Just download `WifiCity_win_v1.0.zip`, unzip, execute `WifiCity_win.bat` and follow the instructions.

## How does it work

When you use `WifiCity_win.bat` it does 2 things:
1. It will write a script equivalent to `login_wifi.bat` in `C:\Windows\System32` folder containing your WifiCity credentials.
2. It will create a windows task scheduler that will launch automatically the script every time the computer connect to WifiCity network (and only this network).

Then, the script does some web request to authenticate yourself on the server.
