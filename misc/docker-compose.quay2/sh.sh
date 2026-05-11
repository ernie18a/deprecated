# curl podman-compose dosent work
YI python3-pip podman podman-docker ; PIU podman-compose
# podman login registry.redhat.io -u sha***... -p ***700***
podman exec -it postgresql /bin/bash -c 'echo "CREATE EXTENSION IF NOT EXISTS pg_trgm" | psql -d quay -U postgres'
podman run -d -it --name quay_config -p 80:8080 -p 443:8443 registry.redhat.io/quay/quay-rhel8:v3.7.3 config secret
mkdir -p /QUAY/{postgres,config,storage}
touch /etc/containers/nodocker
# note
	quay_config login: quayconfig / secret
