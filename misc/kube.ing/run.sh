kubectl delete secret lab.ing
kubectl delete ing nginx
kubectl delete pod nginx
kubectl delete svc nginx
# TLS
openssl genrsa -out tls.key 2048
openssl req -new -key tls.key -out tls.csr -subj "/CN=r224"
openssl x509 -req -in tls.csr -signkey tls.key -out tls.crt
kubectl create secret tls lab.ing --key tls.key --cert tls.crt
# 
kubectl run --image=nginx nginx --port 80
kubectl expose pod nginx --type=ClusterIP --name=nginx --port=80
kubectl apply -f .
