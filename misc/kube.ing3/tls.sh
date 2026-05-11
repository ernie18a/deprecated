openssl genrsa -out tls.key 2048
openssl req -new -key tls.key -out tls.csr -subj "/CN=a.b.cc" -days 7300
openssl x509 -req -days 18250 -in tls.csr -signkey tls.key -out tls.crt
kubectl create secret tls awxtls --key tls.key --cert tls.crt
