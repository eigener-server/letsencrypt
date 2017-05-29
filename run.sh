#!/bin/bash

# Hedgehog Cloud by www.eigener-server.ch https://www.eigener-server.ch/en/igel-cloud \
# is licensed under a Creative Commons Attribution 4.0 International Lizenz \
# http://creativecommons.org/licenses/by/4.0/ \
# To remove the links visit https://www.eigener-server.ch/en/igel-cloud"

set -e

# This runs after first start 
if [ ! -f /host/letsencrypt/firstrun ]; then


    # Don't run this again
    touch /host/letsencrypt/firstrun
fi


# This runs after every boot
if [ ! -f /firstrun ]; then


    # Don't run this again
    touch /firstrun
fi

if [ "$1" = 'certbot' ]; then

        shift # "certbot"
        set -- /usr/local/bin/cert.sh "$@"

fi


exec "$@"
