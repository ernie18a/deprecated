[[_TOC_]]
# Prerequisites
- CPUs: 2
- RAM: 4GB
- Disk space: 30GB
- OS: Centos8
- PORT: 8443, 8080, 443
- reference:
  - https://access.redhat.com/documentation/en-us/red_hat_quay/3.5/html/deploy_red_hat_quay_for_proof-of-concept_non-production_purposes/getting_started_with_red_hat_quay
## installation
```bash
yum update -y
yum install -y podman python3-pip.noarch
pip3 install pyyaml
pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz
```
## volume
```io
export QUAY=/quay
```
```sh
mkdir -p $QUAY/config
mkdir -p $QUAY/storage
mkdir -p $QUAY/postgres-quay
mkdir -p $QUAY/postgres-clairv4
```
# podman run
## psql
```sh
podman run -d --rm --name postgresql-quay \
  -e POSTGRESQL_USER=quayuser \
  -e POSTGRESQL_PASSWORD=quaypass \
  -e POSTGRESQL_DATABASE=quay \
  -e POSTGRESQL_ADMIN_PASSWORD=adminpass \
  -p 5432:5432 \
  -v $QUAY/postgres-quay:/var/lib/pgsql/data:Z \
  registry.redhat.io/rhel8/postgresql-10:1
```
## psql-clair
```sh
podman run -d --rm --name postgresql-clairv4 \
  -e POSTGRESQL_USER=clairuser \
  -e POSTGRESQL_PASSWORD=clairpass \
  -e POSTGRESQL_DATABASE=clair \
  -e POSTGRESQL_ADMIN_PASSWORD=adminpass \
  -p 5433:5432 \
  -v $QUAY/postgres-clairv4:/var/lib/pgsql/data:Z \
  registry.redhat.io/rhel8/postgresql-10:1
```
## redis
```sh
podman run -d --rm --name redis \
  -p 6379:6379 \
  -e REDIS_PASSWORD=strongpassword \
  registry.redhat.io/rhel8/redis-5:1
```
### podman exec -it psql
```sh
podman exec -it postgresql-quay /bin/bash -c 'echo "CREATE EXTENSION IF NOT EXISTS pg_trgm" | psql -d quay -U postgres'
podman exec -it postgresql-clairv4 /bin/bash -c 'echo "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"" | psql -d clair -U postgres'
```
## quay-conf
- well kill this process later
```sh
podman run --rm -it --name quay_config -p 8080:8080 registry.redhat.io/quay/quay-rhel8:v3.5.1 config secret
```
### pw
- user: quayconfig
- pw: secret 
## clair
```sh
podman run -d --rm --name clairv4 \
  -p 8081:8081 -p 8089:8089 \
  -e CLAIR_CONF=/clair/config.yaml -e CLAIR_MODE=combo \
  -v /etc/clairv4/config:/clair:Z \
  registry.redhat.io/quay/clair-rhel8:v3.5.1
```
## quay
```sh
podman run -d --rm -p 8080:8080  \
   --name=quay \
   -v $QUAY/config:/conf/stack:Z \
   -v $QUAY/storage:/datastorage:Z \
   registry.redhat.io/quay/quay-rhel8:v3.5.1
```
# podman login
```sh
podman login registry.redhat.io -u '14498751|-futurama' -p 'eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIwMjU3ZjgyZTNkMDg0ZjUxYWYxZWQyMjc5Y2IyMWViZCJ9.RnBvQ2leXa2ILi3JNucVnET6NKR_u2bAZK2INX4qSUN0xG0s0nIZI3oLJqfqxShLzV-PzshW03hQancxfnLCgS0feFnOooA_GEWGsgkQ40GcaOOoA3xmCuiqr7YqF89Qj_rRy4fmto2h5DAiGzKuMvsRT58mncIhAJs8SAXv42fcDz02y3fAoKpwB8pEdJu6S1DRLQVpFv0b0PUxJ6XzcnG9pMJFTzdb6QcwVw1YDzspNL9dtYHfHQOgFR6QvQvGPxyXau6JsqG9pD5lDQ_F1VKJy0s8xLU4QNBe_T4Qc0ubMG3O0p6m2_S3p56TM8w7Z_RzoCv3kdpRvUEvoKp-XOq43FIYEqlQw8mNJ0gzxqIwZNdakg0t5MfI72drcerqC1Cu2X9nuXWYeR4HXOggvUoDUrON4gwFnMRw6wMq-FfS4UGlyhkTjKAbd6npxiS0FQaQj9KCwFwG1kG7ezkUjgsnz1gAlW9lmV3XddcfVSLE5pU-C8u7EAAP_1KVIw-se6a60gEwX-KRXC6R6MLchcytFFdrJ5TnYLAHXhRmKKeSrTaGF6-seYnx449Cz96p4i582nxpzaIKBERxz0Mwqxrug37Pp6A8VJ-Mw23uzHW9vfZsxkZAfZZAFXH52dK9rb0NRbw9du9iKtrND4z9Uc0lJgcLk7MHAgCi-V_XNHo'
```
# known issues
## env
```sh
podman run  --rm --name clairv4   -p 8081:8081 -p 8089:8089   -e CLAIR_CONF=/clair/config.yaml -e CLAIR_MODE=combo   -v /etc/clairv4/config:/clair:Z   registry.redhat.io/quay/clair-rhel8:v3.5.1
must provide a -conf flag or set "CLAIR_CONF" in the environment
```
# misc
- /etc/containers/registries.conf
- podman login --tls-verify=false 192.168. -u -p 
- podman push --tls-verify=false 192.168.x.x/xxx/b:1.0.0
