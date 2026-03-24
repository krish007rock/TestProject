#!/bin/sh

if [ "${ENABLE_SSHD}" == "1" ]
then
    #  Start sshd
    echo "root:Docker!" | chpasswd
    chmod 711 /var/empty/sshd
    mv /sshd_config /etc/ssh
    ssh-keygen -A
    /usr/sbin/sshd
fi

#  Update APPINSIGHTS_INSTRUMENTATIONKEY runtime variables
mv /usr/share/nginx/html/assets/config/data/portal-env.json /portal-env.json
envsubst '$APPINSIGHTS_INSTRUMENTATIONKEY' < /portal-env.json > /usr/share/nginx/html/assets/config/data/portal-env.json

#  Update AA_BACKEND_PROXY_HOST & PROXY_HOST in nginx conf file
envsubst '$AA_BACKEND_PROXY_HOST,$PROXY_HOST' < /accounts-portal.conf > /etc/nginx/conf.d/accounts-portal.conf

# Update ADOBE_EMBED_CODE in index.html file
mv /usr/share/nginx/html/index.html /index.html
envsubst '$ADOBE_EMBED_CODE' < /index.html > /usr/share/nginx/html/index.html

nginx -g 'daemon off;'
