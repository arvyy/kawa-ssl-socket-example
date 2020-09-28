#!/bin/bash
if [ ! -f keyStore.pkcs12 ]; then
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
    openssl pkcs12 -export -out keyStore.pkcs12 -inkey key.pem -in cert.pem -password pass:password
fi
kawa -Djavax.net.ssl.keyStore=keyStore.pkcs12 -Djavax.net.ssl.keyStorePassword=password tlssocket.scm
