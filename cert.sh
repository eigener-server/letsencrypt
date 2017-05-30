#!/bin/bash

# Hedgehog Cloud by www.eigener-server.ch https://www.eigener-server.ch/en/igel-cloud \
# is licensed under a Creative Commons Attribution 4.0 International Lizenz \
# http://creativecommons.org/licenses/by/4.0/ \
# To remove the links visit https://www.eigener-server.ch/en/igel-cloud"

regex_domain="^([a-zA-Z0-9_-]([a-zA-Z0-9_-]*[a-zA-Z0-9_-])?\.)+[a-zA-Z0-9_-]([a-zA-Z0-9_-]*[a-zA-Z0-9])?\$"
regex_mail="^[a-z0-9!#%&*+=_{|}~-]+(\.[a-z0-9!#%&*+=_{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

if [ "$1" = 'staging' ]; then
    shift # "staging"
    command_staging="--staging"

fi

if [[ $1 =~ $regex_mail ]];then
    mail=$1
    echo "Mail ok $mail"
    shift # mail
else
    echo "Mail not OK $mail"
    echo "Please use following parameters: YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
    echo "and the following for test: staging YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
    exit 1
fi

if [ "$#" -lt 1 ]; then
    echo "Domain missing"
    echo "Please use following parameters: YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
    echo "and the following for test: staging YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
    exit 1
fi

master_domain=$1
cert_dir_pem="/host/letsencrypt/certs/pem"
command_exec="certbot certonly --webroot --agree-tos -n -w /var/www/html/"
command_pem="cat /etc/letsencrypt/live/$master_domain/fullchain.pem /etc/letsencrypt/live/$master_domain/privkey.pem > $cert_dir_pem/$master_domain.pem"
command_parameter="-m $mail"

for domain in "$@"
do
    if [[ $domain =~ $regex_domain ]];then
        echo "Domain ok $domain"
        command_parameter="$command_parameter -d $domain"
    else
        echo "Domain not OK $domain"
        echo "Please use following parameters: YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
        echo "and the following for test: staging YOUR_EMAIL YOUR_DOMAIN_1 YOUR_DOMAIN_2 ..."
        exit 1
    fi
done

mkdir -p $cert_dir_pem
$command_exec $command_staging $command_parameter
$command_pem

