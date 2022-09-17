#!/bin/bash

# config

WEB_HOST="some.host"
WEB_USER="me"
WEB_ROOT="/path/to/webtroot"
FILENAME="myfile"
EXTRACMDS=""
IPINFO="https://ipinfo.io/ip"

# end config

IP=$(curl -k --silent $IPINFO)

OIP=$(curl -k --silent https://$WEB_HOST/$FILENAME)

if [ $IP != $OIP ]; then
    ssh $WEB_USER@$WEB_HOST -C "echo $IP > $WEB_ROOT/$FILENAME $EXTRACMDS"
fi
