#!/bin/bash

cat >>/etc/opendkim.conf <<EOF
AutoRestart             Yes
AutoRestartRate         10/1h
Canonicalization        relaxed/simple
Domain                  *
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyFile                 /etc/opendkim/keys/$DOMAIN/mail.private
LogWhy                  Yes
Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
Selector                mail
SignatureAlgorithm      rsa-sha256
Socket                  inet:12301@localhost
Syslog                  yes
SyslogSuccess           Yes
UMask                   002
UserID                  opendkim:opendkim
EOF

cat >>/etc/default/opendkim <<EOF
SOCKET="inet:12301@localhost"
EOF

mkdir -p /etc/opendkim/keys

cat >/etc/opendkim/TrustedHosts <<EOF
$(echo ${TRUSTED_HOSTS} | sed 's/[ ]/\n/g')
EOF

cat >>/etc/opendkim/KeyTable <<EOF
mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/opendkim/keys/$DOMAIN/mail.private
EOF

cat >>/etc/opendkim/SigningTable <<EOF
*@$DOMAIN mail._domainkey.$DOMAIN
EOF

mkdir -p /etc/opendkim/keys/$DOMAIN
if [[ -v DKIM_KEY && -v DKIM_TXT ]]; then
  echo -e "${DKIM_KEY}" > /etc/opendkim/keys/$DOMAIN/mail.private
  echo -e "${DKIM_TXT}" > /etc/opendkim/keys/$DOMAIN/mail.txt
elif [ ! -d /etc/opendkim/keys/$DOMAIN ]; then
  opendkim-genkey --directory=/etc/opendkim/keys/$DOMAIN --selector=mail --domain=$DOMAIN --bits=1024
fi
chown opendkim:opendkim /etc/opendkim/keys/$DOMAIN/mail.private
chmod 700 /etc/opendkim/keys/$DOMAIN/mail.private

opendkim-testkey

