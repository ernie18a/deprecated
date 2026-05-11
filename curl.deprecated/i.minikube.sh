curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube completion bash  > /etc/bash_completion.d/minikube
echo 'sudo su - $(ls /home/)'
echo 'minikube start --cpus=6 --memory=6g --addons=ingress'
echo 'pre-request kubernetes & docker '
