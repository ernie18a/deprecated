useradd -ms/bin/bash u4
echo 'u4:p4' | chpasswd
openssl genpkey -algorithm RSA -out u4-client-key.pem
openssl req -new -key /home/u4/u4-client-key.pem -out /home/u4/u4-client-csr.pem -subj "/CN=u4"
openssl x509 -req -in /home/u4/u4-client-csr.pem -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /home/u4/u4-client-cert.pem -days 365
kubectl create serviceaccount u4-serviceaccount -n test
kubectl create role u4-full-access --verb=* --resource=* -n test
kubectl create rolebinding u4-rolebinding --role=u4-full-access --serviceaccount=test:u4-serviceaccount --user=u4 -n test
kubectl config set-credentials u4 --user=u4 --client-certificate=u4-client-cert.pem --client-key=u4-client-key.pem
kubectl config set-context u4-context --cluster=kubernetes --user=u4 --namespace=test
kubectl config use-context u4-context
