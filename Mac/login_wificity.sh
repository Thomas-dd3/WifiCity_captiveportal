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

    # parsing http status code
    status_code=$(sed -n '1s/^[^ ]* \([0-9]*\) \(.*\)$/\1/p' <<< "$gen204_resp")

    # if http status code is not expected
    if [ "$status_code" != "204" ]; then
        # captive portal is detected
        # assuming wificity network
        # parsing magic code to generate the wificity authentication form
        magic=$(sed -n 's/^Location.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        # generate the authentication form
        curl -so /dev/null "${authserver}/fgtauth?${magic}"
        # submit credentials with magic code to wificity server for authentication
        curl -so /dev/null "$authserver" --data "magic=${magic}&username=${username}&password=${password}"
    fi
}

# change to your correct USERNAME PASSWORD
login_wificity USERNAME PASSWORD

# eg. login_wificity CFB_001 qweRT6YU
