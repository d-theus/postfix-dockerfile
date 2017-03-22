FROM debian:jessie
MAINTAINER Andrew Dorofeyev (http://github.com/d-theus)

RUN apt-get update && \
    apt-get install -y postfix opendkim openssl syslog-ng --no-install-recommends && \
    apt-get clean

ENV TRUSTED_HOSTS "127.0.0.1 ::1 localhost 172.17.0.0"
ADD main.cf /etc/postfix
ADD setup-syslog-ng.sh /opt
ADD setup-opendkim.sh /opt
ADD setup-postfix.sh /opt
ADD setup-postmap.py /opt

EXPOSE 25

CMD if [ -d /etc/opendkim/keys ]; then\
      /opt/setup-syslog-ng.sh;\
      /opt/setup-opendkim.sh;\
      /opt/setup-postfix.sh;\
      /opt/setup-postmap.py;\
      fi;\
      postmap /etc/postfix/virtual;\
      syslog-ng --no-caps;\
      opendkim;\
      postfix start;\
      tail -F /var/log/mail*
