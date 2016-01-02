FROM centos:centos7
MAINTAINER d-theus(http://github.com/d-theus)
EXPOSE 25
RUN cat /etc/yum/pluginconf.d/fastestmirror.conf  | sed 's/enabled=1/enabled=0/g' > /etc/yum/pluginconf.d/fastestmirror.conf
RUN yum -y update
RUN yum -y install postfix
ADD main.cf /etc/postfix
ADD virtual /etc/postfix
RUN postmap /etc/postfix/virtual
CMD /bin/bash
