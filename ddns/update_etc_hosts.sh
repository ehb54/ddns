#!/bin/bash                                                                                                                                                                                                           

## config                                                                                                                                                                                                             

HOSTS_FILE="/etc/hosts"
HOSTS_ENTRY="myhost.local"
DDNS_NAME="myhost.ydns.eu"

## get current IP                                                                                                                                                                                                     
IP=`getent hosts $DDNS_NAME | awk '{ print $1 }'`

# echo IP is $IP                                                                                                                                                                                                      

sed -i "s/^.*$HOSTS_ENTRY/$IP $HOSTS_ENTRY/" $HOSTS_FILE
