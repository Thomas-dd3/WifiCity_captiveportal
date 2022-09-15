#!/bin/bash

# https://wiki.archlinux.org/index.php/NetworkManager#Captive_portals

# README : make sure these binaries are available on your distribution.
# curl sed

login_wificity() {
    # wificity authentication server
    authserver="http://10.254.0.254:1000"
    
    # 204 http status code generation url to detect captive portal
    # can be any http address, eg. http://neverssl.com
    # but change the "$status" != "204" with correct status code
    # ref. https://github.com/NickSto/uptest/blob/master/captive-portals.md
    gen204="http://www.google.com/gen_204"
    
    # wificity username password
    username=$1
    password=$2
    
    # grabbing http response to detect captive portal
    gen204_resp=$(curl -si "$gen204")
    
    #echo "gen204 response:"
    #echo $gen204_resp
    #echo
    
    # parsing http status code
    status_code=$(sed -n '1s/^[^ ]* \([0-9]*\) \(.*\)$/\1/p' <<< "$gen204_resp")
    
    #echo "status code (204 if already logged in):"
    #echo $status_code
    #echo
 
    # if http status code is not expected
    if [ "$status_code" != "204" ]; then
        # captive portal is detected
        # assuming wificity network
        # parsing magic code to generate the wificity authentication form
        #magic=$(sed -n 's/^Location.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        magic=$(sed -n 's/.*window\.location=.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        # generate the authentication form
        curl -so /dev/null "${authserver}/fgtauth?${magic}"
        # submit credentials with magic code to wificity server for authentication
        curl -so /dev/null "$authserver" --data "magic=${magic}&username=${username}&password=${password}"
    fi
}

check_loggedin() {
    # wificity authentication server
    authserver="http://10.254.0.254:1000"
    
    # 204 http status code generation url to detect captive portal
    # can be any http address, eg. http://neverssl.com
    # but change the "$status" != "204" with correct status code
    # ref. https://github.com/NickSto/uptest/blob/master/captive-portals.md
    gen204="http://www.google.com/gen_204"
    
    # wificity username password
    username=$1
    password=$2
    
    # grabbing http response to detect captive portal
    gen204_resp=$(curl -si "$gen204")
    
    #echo "gen204 response:"
    #echo $gen204_resp
    #echo
    
    # parsing http status code
    status_code=$(sed -n '1s/^[^ ]* \([0-9]*\) \(.*\)$/\1/p' <<< "$gen204_resp")
    
    #echo "status code (204 if already logged in):"
    #echo $status_code
    #echo
    
    # if http status code is not expected
    if [ "$status_code" != "204" ]; then
        # captive portal is detected
        # assuming wificity network
        # parsing magic code to generate the wificity authentication form
        #magic=$(sed -n 's/^Location.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        magic=$(sed -n 's/.*window\.location=.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        echo 1
        
        #echo "magic:"
        #echo $magic
        #echo
    else
        echo 0
    fi
}

check_ssid() {
    # parse ssid
    ssid=$(sed -n 's/^Current Wi-Fi Network: \(.*\)/\1/p' <<< "$(networksetup -getairportnetwork en0)")

    if [ "$ssid" == "WifiCity" ]; then
        echo 0
    fi
}

# quit if we're not connected to WifiCity
if [ "$(check_ssid)" != "0" ]; then
    exit 0
fi

# quit if we've alreadly logged in to WifiCity
if [ "$(check_loggedin)" == "0" ]; then
    osascript -e 'display notification "Already logged in!" with title "WifiCity"'
    exit 0
fi

# change to your correct USERNAME PASSWORD
login_wificity USERNAME PASSWORD
# eg. login_wificity CFB_001 qweRT6YU

# check if we've alreadly logged in to WifiCity, otherwise, display debug notifications
if [ "$(check_loggedin)" != "0" ]; then
    check_loggedin
    osascript -e 'display notification "Failed to log in!" with title "WifiCity"'
    # cf. https://stackoverflow.com/a/23923108
    osascript -e 'display notification "'"content: ${gen204_resp//\"/}"'" with title "DEBUG 1/3 gen204 response"'
    osascript -e 'display notification "'"content: ${status_code//\"/}"'" with title "DEBUG 2/3 status code (204 if already logged in)"'
    osascript -e 'display notification "'"content: ${magic//\"/}"'" with title "DEBUG 3/3 magic"'
else
    osascript -e 'display notification "Logged in!" with title "WifiCity"'
fi

