# WifiCity_captiveportal

Tired to enter your credential everytime you connect to WifiCity, these scripts are made for you.

The main goal of this repository is to offer a solution to connect automaticaly on internet while the computer is connected at the CIUP wifi called WifiCity.


****************************************************************************
I have used [this linux script](https://gist.github.com/rnbguy/6f574caa6b3535162a20750cb1777a09) as a base of my work. Thanks [Ranadeep Biswas](https://gist.github.com/rnbguy) !
I haven't change the script for linux (it works perfectly). I just add some documentation.
Then I rewrote the script to work on windows.
****************************************************************************


## Prerequisite

Nothing, currently worked well with Windows and Linux.

## How to use

### Windows

* Open the Windows folder and download `WifiCity_win_v1.0.zip`
* Extract the zip file

**First use:**
1. Open the file WifiCity_win.bat (double click)
2. Autorize the admin prompt window (click on yes)
3. Type 1 then press enter
4. Enter your WifiCity credential, login (enter), password (enter)
5. Close the terminal with the close icon or enter 3

**Remove the set up:**
1. Open the file WifiCity_win.bat (double click)
2. Autorize the admin prompt window (click on yes)
3. Type 2 then press enter
5. Close the terminal with the close icon or enter 3


### Linux

* Open the Linux folder and download `login_wifi.sh`
* Edit the file with your own credential
* Automate the execution of the script every time you connect to a wifi with the following

NetworkManager has the ability to start services when you connect to a network and stop them when you disconnect (e.g. when using NFS, SMB and NTPd).

To activate the feature you need to enable and start the `NetworkManager-dispatcher.service`.
```bash=
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl start NetworkManager-dispatcher.service
```

Once the service is active, scripts can be added to the `/etc/NetworkManager/dispatcher.d` directory.

```bash=
cd /etc/NetworkManager/dispatcher.d
#copy your script to that directory
cp /home/<user>/<...>/login_wifi.sh ./10-login_wifi.sh
```

Scripts must be owned by root, otherwise the dispatcher will not execute them. For added security, set group ownership to root as well: 
```bash=
chown root:root /etc/NetworkManager/dispatcher.d/10-login_wifi.sh
chmod 755 /etc/NetworkManager/dispatcher.d/10-login_wifi.sh
```

Then reboot and it will automatically execute your script while connected to a network.


### Mac

The linux script should work for Mac as well. Nevertheless no work have been done to execute the script automatically while connected to a network. One idea is to use [ControlPlane](https://www.controlplaneapp.com/) to triger connexion to a wifi and then automatically execute the script.

## On Android

Execute the linux script with [`Termux`](https://play.google.com/store/apps/details?id=com.termux&fbclid=IwAR0VU0hSW3z2qZTTrm0dH72awzus8Sy-hZXMOPSG6mdUe5M2cq5zRYW0Q8o) and use this [widget](https://play.google.com/store/apps/details?id=com.termux.widget&fbclid=IwAR0rr7g7ghvPZ8juKe1ses1xXTzq50hbIcUDUcbozzb87_pKllknFPW8TBQ) to execute it from home screen.

## On IOS

One idea is to use the app ***Shortcuts*** but with ios 12 it doesn't seem to be possible but it might be with most recent version of ios.