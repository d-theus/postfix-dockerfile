#!/bin/bash

postconf -e myhostname=$DOMAIN
postconf -e mydestination=smtp.$DOMAIN,mail.$DOMAIN,$DOMAIN

