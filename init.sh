#!/bin/bash
set -e

MAIL_DOMAIN=${MAIL_DOMAIN:-}
URL_HOST=${URL_HOST:-}
LANGUAGE=${LANGUAGE:-EN}
MM_PASSWORD=${MM_PASSWORD:-password}
MM_SITEPASS=${MM_SITEPASS:-myunsecurepwd}
ADMIN_EMAIL=${ADMIN_EMAIL:-}

export MAIL_DOMAIN
export URL_HOST
export LANGUAGE
export MM_PASSWORD
export MM_SITEPASS
export ADMIN_EMAIL


postconf -e "relay_domains = $MAIL_DOMAIN"
postconf -e 'transport_maps = hash:/etc/postfix/transport'
postconf -e 'mailman_destination_recipient_limit = 1'
postconf -e 'alias_maps = hash:/etc/aliases, hash:/var/lib/mailman/data/aliases'
echo "$MAIL_DOMAIN  mailman:" > /etc/postfix/transport
postmap -v /etc/postfix/transport

cp -f /etc/mailman/mm_cfg.py.tpl /etc/mailman/mm_cfg.py
# Substitute configuration
for VARIABLE in `env | cut -f1 -d=`; do
  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/mailman/mm_cfg.py
done

# move template to mounted volume
if [ ! -d "/var/spool/postfix/defer" ]; then
	cp -rp /postfixtemplate/* /var/spool/postfix/
fi

if [ ! -d /var/lib/mailman/lists ] 
then
  rsync -a --progress /mailman/ /var/lib/mailman/
fi

NB_LISTS=$(ls /var/lib/mailman/lists | wc -l)
if [ $NB_LISTS -eq 0 ]
then 
  newlist --quiet mailman $ADMIN_EMAIL $MM_PASSWORD
fi

#chown root:list /var/lib/mailman/data/aliases
chown root:list /etc/aliases
newaliases
mmsitepass $MM_SITEPASS
/usr/lib/mailman/bin/genaliases

/etc/init.d/postfix start
/etc/init.d/mailman start
/etc/init.d/apache2 start

tail -f /var/log/mailman/*
