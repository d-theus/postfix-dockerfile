#!/usr/bin/python

import os

if not 'VIRTUAL' in os.environ:
    exit(0)
strings = os.environ['VIRTUAL'].split(':')

f = open('/etc/postfix/virtual', 'w')

for ent in strings:
  words = ent.split(' ')
  src = words[0]
  tos = words[1:]
  f.write(src + '@' + os.environ['DOMAIN'] + ' ' + ' '.join(tos) + '\n')

f.close()
