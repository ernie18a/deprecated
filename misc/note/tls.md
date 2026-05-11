```bash
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 24855 -out rootCA.pem -config openssl.cnf
openssl genrsa -out ssl.key 2048
openssl req -new -key ssl.key -out ssl.csr -config openssl.cnf
openssl x509 -req -in ssl.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out ssl.cert -days 356 -extensions v3_req -extfile openssl.cnf
openssl x509 -noout -modulus -in ssl.cert | openssl md5
openssl rsa -noout -modulus -in ssl.key | openssl md5
openssl req -noout -modulus -in ssl.csr | openssl md5
```
```bash
window openssl config
set OPENSSL_CONF=D:\jboss_apache\jbcs-httpd24-httpd-2.4.37-win6-x86_64\jbcs-httpd24-2.4\etc\ssl\openssl.cnf
openssl genrsa -des3 -out rootCA.key 4096  <-- root.ca
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 36500 -out rootCA.crt <-- root.key
openssl genrsa -out darkthread-net.key 2048 <-- server.key
建立.cnf 
=====================================
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C=TW
ST=Taiwan
L=Taipei
O=Darkthread
OU=Darkthread CA
emailAddress=nobody@darkthread.net
=====================================
openssl req -new -sha256 -nodes -key darkthread-net.key -out darkthread-net.csr -config darkthread-net.cnf <-- server.csr
建立v3.ext設定檔
=====================================
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.darkthread.net
=====================================
openssl x509 -req -in darkthread-net.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out darkthread-net.crt -days 36500 -sha256 -extfile darkthread-net-v3.ext <-- server.crt
crt convert to p12 
openssl pkcs12 -export -in from.crt -inkey privatekey.key -out to.p12 -name "alias" <-- server.p12
p12 convert t0 jks
keytool -importkeystore -srckeystore keystore.p12 -destkeystore keystore.jks -deststoretype pkcs12 <-- server.jks
```
