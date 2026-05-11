```
openssl genrsa -out r224.key 2048
openssl req -new -key r224.key -out r224.csr
openssl x509 -req -days 365 -in r224.csr -signkey r224.key -out r224.crt
```
