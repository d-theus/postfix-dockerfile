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

cat >>/etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
EOF

mkdir -p /etc/opendkim/keys/$DOMAIN
cat >>/etc/opendkim/KeyTable <<EOF
mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/opendkim/keys/$DOMAIN/mail.private
EOF

cat >>/etc/opendkim/SigningTable <<EOF
*@$DOMAIN mail._domainkey.$DOMAIN
EOF

opendkim-genkey --directory=/etc/opendkim/keys/$DOMAIN --selector=mail --domain=$DOMAIN --bits=1024
chown opendkim /etc/opendkim/keys/$DOMAIN/mail.private

