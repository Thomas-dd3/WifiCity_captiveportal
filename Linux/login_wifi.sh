#!/bin/bash

# https://wiki.archlinux.org/index.php/NetworkManager#Captive_portals

login_wificity() {
    authserver="http://10.254.0.254:1000"
    gen204="http://www.google.com/gen_204"
    username=$1
    password=$2

    gen204_resp=$(curl -si "$gen204")

    status=$(echo "$gen204_resp" | head -n1 | cut -d' ' -f2)

    if [ "$status" != "204" ]; then
        magic=$(echo "$gen204_resp" | awk /Location/ | sed -e 's/^.*?\([a-zA-Z0-9]\+\).*$/\1/g')
        curl -so /dev/null "${authserver}/fgtauth?${magic}"
        curl -so /dev/null "$authserver" --data "magic=${magic}&username=${username}&password=${password}"
    fi
}

# change to your correct USERNAME PASSWORD
login_wificity USERNAME PASSWORD

# eg. login_wificity CFB_001 qweRT6YU
