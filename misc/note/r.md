[[_TOC_]]
# top
```
L,&,<,> . Locate: 'L'/'&' find/again
u,U,o,O . Filter by: 'u'/'U' effective/any user
V,v     . Toggle: 'V' forest view; 'v' hide/show forest view children
k,r       Manipulate tasks: 'k' kill; 'r' renice
```
# psql
```sh
psql -d t9f -U t9f -w 762ed1aa0f4e44b6ba2c0ac24f1f623b  -h 172.0.10.168 -p 5532
- /var/lib/pgsql/11/data/postgresql.conf
- /var/lib/pgsql/11/data/pg_hba.conf
```
```
cat test.sh
#! /bin/sh
echo '$#' $#
echo '$@' $@
echo '$?' $?
```
```
bash test.sh 1 2 3
$#  3
$@  1 2 3
$?  0
```
```
cat deployment.yaml
spec:
  replicas: $REPLICA_COUNT
  revisionHistoryLimit: $HISTORY_LIM
```
```
export REPLICA_COUNT=10 HISTORY_LIM=10
envsubst < deployment.yaml
spec:
  replicas: 10
  revisionHistoryLimit: 10
```
# psql
```
su - postgres
create database t9f ;
create user t9f with encrypted password '762ed1aa0f4e44b6ba2c0ac24f1f623b';
grant all privileges on database t9f to t9f;
pg_hba.conf
pg_ctl restart
psql  -d t9f -h 172.0.10.168 -p 5432 -U t9f -f aa
pg_dump -d t9f -h 172.0.10.168 -p 5532 -U t9f -f DB.BACKUP.FILE
postgres=# create database mydb;
postgres=# create user myuser with encrypted password 'mypass';
postgres=# grant all privileges on database mydb to myuser;
psql -d postgresdb -U postgresadmin -W admin123 -h 172.16.226.69
sudo -u postgres psql # -d t9f
/var/lib/pgsql/11/data/postgresql.conf
/var/lib/pgsql/11/data/pg_hba.conf
```
# tmux
```
  C-b Alt-1             # vertical split, all panes same width 
# C-b Alt-2             # horizontal split, all panes same height 
# C-b Alt-3             # horizontal split, main pane on top, 
                      other panes on bottom, vertically split, all same width 
  C-b Alt-4             # vertical split, main pane left, 
                      other panes right, horizontally split, all same height 
  C-b M-5             # tile, new panes on bottom, same height before same width 
# zooming 
C-b z  
prefix + ctrl + o 
C-b + Page Up/ down
ctrl+b x Kill Pane
C +{ move current pane up
```
# vim
- insert text at beginning of selected line: ctrl-v line > shift-i > (input text) > (esc) > done
# MISC
# ssh_config
```
StrictHostKeyChecking no
ServerAliveInterval 30
#TcpKeepAlive yes
#ServerAliveCountMax 3 
```

## sudoers
```
A     ALL=(ALL) NOPASSWD:ALL
```
```
echo 'A     ALL=(ALL) NOPASSWD:ALL' >>  /etc/sudoers
```



# bash
# curl
```
-f, --fail          Fail silently (no output at all) on HTTP errors
-s, --silent        Silent mode
-S, --show-error    Show error even when -s is used
-L, --location      Follow redirects # tl;dr: redirects
```

# /etc/docker/daemon.json
```
{
  "insecure-registries":["172.0.10.190:80"], # fixing docker login "http: server gave HTTP response to HTTPS client" issue.
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
```
### gitlab markdown syntax highlight
```
io
java
powershell
puppet
yaml
```
## ssh into wsl
```
service ssh --full-restart
nano /etc/ssh/sshd_config
AllowUsers yourusername
PasswordAuthentication yes
service ssh --full-restart
```
- https://superuser.com/questions/1111591/how-can-i-ssh-into-bash-on-ubuntu-on-windows-10
