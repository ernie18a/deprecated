podman run -d --rm --name clairv4 \
  -p 8081:8081 -p 8089:8089 \
  -e CLAIR_CONF=/clair/config.yaml -e CLAIR_MODE=combo \
  -v /etc/clairv4/config:/clair:Z \
  registry.redhat.io/quay/clair-rhel8:v3.4.4

podman run -d --rm -p 80:8080  -p 443:8443 -p 7443:7443\
   --name=quay \
   -v /quay/config:/conf/stack:Z \
   -v /quay/storage:/datastorage:Z \
   registry.redhat.io/quay/quay-rhel8:v3.4.4

