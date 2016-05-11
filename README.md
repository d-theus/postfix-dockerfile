# postfix-dockerfile
Postfix w/ forwarding and DKIM on CentOS 7

## Usage
`docker run -d --name postfix -p 25:25 \
-e DOMAIN=example.com \
-e VIRTUAL="forward-me to-here@gmail.com:forward-also to-here@gmail.com" \
postfix-dkim
`


