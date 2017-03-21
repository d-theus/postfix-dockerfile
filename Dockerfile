FROM centos:centos7
MAINTAINER Andrew Dorofeyev (http://github.com/d-theus)
RUN cat /etc/yum/pluginconf.d/fastestmirror.conf  | sed 's/enabled=1/enabled=0/g' > /etc/yum/pluginconf.d/fastestmirror.conf
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y update; yum -y install postfix opendkim opendkim-tools openssl syslog-ng; yum clean all
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
