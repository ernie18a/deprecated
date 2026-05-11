kubectl create ns awx
kubectl create secret generic awx-admin-password2 --namespace=awx --from-literal=password=3
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout awx.key -out awx.crt
kubectl create secret tls awx-tls --cert=awx.crt --key=awx.key
