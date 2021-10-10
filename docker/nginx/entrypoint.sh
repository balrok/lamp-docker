#!/bin/bash

# TODO remove set -x
set -x
date

if [[ "$TYPE" == "yii" ]]; then
    cp yii.conf /etc/nginx/conf.d/default.conf
else
    echo "Unsupported TYPE=$TYPE - only 'yii' is supported at the moment"
    exit 1
fi
if [[ -z "$SERVERNAME" ]]; then
    echo "Error: SERVERNAME is empty. SERVERNAME is used for the domain name (server_name SERVERNAME;)"
    exit 1
fi
if [[ -z "$SERVERDIR" ]]; then
    echo "Error: SERVERDIR is empty. SERVERDIR is used for the directory name (root SERVERDIR;)"
    exit 1
fi

sed -i "s?SERVERNAME?$SERVERNAME?" /etc/nginx/conf.d/default.conf
sed -i "s?SERVERDIR?$SERVERDIR?" /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
