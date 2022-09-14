#!/bin/bash                                                                                                                                                                                                          

## config                                                                                                                                                                                                            

WEB_HOST="some.host"
FILENAME="myfile"
HOSTS_FILE="/etc/hosts"
HOSTS_ENTRY="myhost.local"

## get current IP
IP=$(curl -k --silent https://$WEB_HOST/$FILENAME)

# echo IP is $IP

sed -i "s/^.*$HOSTS_ENTRY/$IP $HOSTS_ENTRY/" $HOSTS_FILE
