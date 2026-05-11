```bash
DRM awx_task awx_web awx_postgres awx_rabbitmq awx_memcached ; PRUNE ; rm ~/.awx
apt update ; apt install -y openssh-client
docker exec -t awx_postgres pg_dump -U awx awx -c  > /tmp/a.sql
psql -Uawx awx < a.sql
scp root@192.168.50.164:/tmp/a.sql .
ansible-playbook -i inventory install.yml
```
# awx official repo
- https://github.com/ansible/awx/blob/9.3.0/INSTALL.md#docker-compose
- change 
```bash
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python"
```
- to
```bash
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python3"
```
