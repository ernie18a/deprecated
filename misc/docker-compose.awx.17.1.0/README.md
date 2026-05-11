[[_TOC_]]
## setup
```bash
git clone -b 17.1.0 https://gitlab.com/ernie18a/awx.git ~/.G/awx
cd ~/.G/awx
mkdir ./configs/redis_socket
chmod 0777 ./configs/redis_socket
docker-compose up -d
```
- after container are running
```bash
cat ~/.G/awx/pg.sql | docker exec -i awx_postgres psql -Uawx
```
## web console login
- user: admin
- pw: password
## known issues 
- WARNING overcommit_memory is set to 0! Background save may fail under low memory condition.
  - To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
## note
- backup
```bash
docker exec awx_postgres pg_dump -U awx > BACKUP.sql
```
- restore
```bash
cat BACKUP.sql | docker exec -i awx_postgres psql -Uawx
```
## reference
- https://github.com/ansible/awx/tree/17.1.0/tools/docker-compose
- https://github.com/ansible/awx/blob/17.1.0/tools/docker-compose.yml
- https://github.com/ansible/awx/blob/17.1.0/tools/docker-compose/README.md
