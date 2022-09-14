#!/bin/bash

# config

WEB_HOST="some.host"
WEB_USER="me"
WEB_ROOT="/path/to/webtroot"
FILENAME="myfile"
EXTRACMDS=""

# end config

IP=$(curl -k --silent https://ydns.io/api/v1/ip)

OIP=$(curl -k --silent https://$WEB_HOST/$FILENAME)

if [ $IP != $OIP ]; then
    # echo updating
    ssh $WEB_USER@$WEB_HOST -C "echo $IP > $WEB_ROOT/$FILENAME $EXTRACMDS"
else
    # echo no change
fi