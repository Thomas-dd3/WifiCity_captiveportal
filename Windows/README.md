# Windows version

## How to use 

Follow the explaination at the repository root readme.

> Just download `WifiCity_win_v1.1.zip`, unzip, execute `WifiCity_win.bat` and follow the instructions.

## How does it work

When you use `WifiCity_win.bat` it does 3 things:
1. It will write a script equivalent to `login_WifiCity.bat` in `C:\Windows\System32` folder containing your WifiCity credentials.
2. It will write a script equivalent to `login_WifiCity.vbs` in `C:\Windows\System32` folder. This *.vbs* script is used to execute the *.bat* script without opening a window so that it is executing in background (without user noticing).
3. It will create a windows task scheduler that will launch automatically the `login_WifiCity.vbs` script every time the computer connect to WifiCity network (and only this network). The script run only when the user is loged in on his windows session.

Then, the script does some web request to authenticate yourself on the server.  


**Sum up schema**  
`Task Scheduler` => `login_WifiCity.vbs` => `login_WifiCity.bat` => **Connected**  



## Ideas of improvement

This solution improved my user experience after I used the `WifiCity_win.bat` program, I was connected faster to the WifiCity network.

*******************************************************

*Unfortunately, with this change, it stopped login me automaticaly after one week of usage and I don't know why.  
Nevertheless, you can give it a try, indeed, you can undo this litle change at anytime.  
If the initial config satisfies you, just go away :)*

*******************************************************

* Open the task scheduler

![](https://i.imgur.com/9qcfFtK.png)

* Click on `Task Scheduler Library`, find `WifiCityAutomaticConnection`, double click on it

![](https://i.imgur.com/D8I5GJu.png)

* Change `Run only when user is logged on` by `Run whether user is logged on or not` and (optional) click on `Do not store password`

![](https://i.imgur.com/kU9qnVW.png)
