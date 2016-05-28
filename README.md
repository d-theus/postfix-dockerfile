# postfix-dockerfile
Postfix w/ forwarding and DKIM on CentOS 7

## Usage
Here and in the sections following substitute `example.com` for your domain.
```sh
docker run -d --name postfix -p 25:25 \
-e DOMAIN=example.com \
-e VIRTUAL="forward-me to-here@gmail.com:forward-also to-here@gmail.com" \
-e TRUSTED_HOSTS="127.0.0.1 ::1 192.168.0.0 192.168.1.0" \
dtheus/postfix-dkim
```

`VIRTUAL` variable is used to specify contents of `/etc/postfix/virtual` file, which
is used here for email forwarding. Lines are separated by colons (`:`).

`TRUSTED HOSTS` variable is used to set entries for `/etc/opendkim/TrustedHosts`.
  Entries are separated by spaces(` `).  By default, it is set to `127.0.0.1 ::1 localhost 172.17.0.0` (default docker network).
  Obviously, `docker run ... -e TRUSTED_HOSTS='...'` overrides it, so you should explicitly
  include default entries if needed. No entries would be added to `TrustedHosts` if trusted
  hosts variable is set to empty string.

*Notice:* no domain supplied for incoming addresses.

## OpenDKIM signatures reuse
If you already have a pair of keys you want to reuse, do the following:

- Put the key pair to some location of your choice on the host. E.g. `/etc/opendkim/keys/example.com/`.
  Selector for this image is not **default** but **mail**, so files should be:
  - mail.txt
  - mail.private
- `run` docker container as mentioned above, but also mount this keys directory of the host:
  ```sh
  -v /etc/opendkim/keys/example.com:/etc/opendkim/keys/example.com
  ```

