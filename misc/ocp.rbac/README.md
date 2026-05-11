# get cluster name
	oc login --server=https://api.ocp4.example.com:6443 --username=car --password=car
# append new user to htpasswd
	htpasswd -B -b FILENAME USERNAME PASSWORD
# deprecated
	oc run --image quay-server.ocp4.example.com/nginx/nginx3:latest  nginx-ernie-test --port 80
	oc run --image=quay.io/ernie2/e4:latest nginx-ernie-test --port 80
