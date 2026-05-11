podman pull ubuntu:20.04
podman tag docker.io/library/ubuntu:20.04 192.168.50.21:8080/eeee/r:20.04
podman push --tls-verify=false 168.50.21:8080/eeee/r:20.04
