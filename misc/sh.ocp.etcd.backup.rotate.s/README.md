[[_TOC_]]
# /etc/crontab
```
[bastion ~ ] # cat /etc/crontab
0 0 */3 * * root bash /opt/etcdbackup.sh
```
# /opt/etcdbackup.sh
```bash
[bastion ~ ] # cat /opt/etcdbackup.sh 
#!/bin/bash
        WM=core@<MASTER_NODE'S_NAME>
        mkdir /ETCD.BACKUP
        cd /ETCD.BACKUP
        ssh $WM << EOF
        mkdir /tmp/.etcdbackup
        sudo /var/usrlocal/bin/cluster-backup.sh /tmp/.etcdbackup
        sudo chown -R core:core /tmp/.etcdbackup
EOF
        scp $VM:/tmp/.etcdbackup/* /ETCD.BACKUP/
        ssh $VM << EOF
        rm -rf /tmp/.etcdbackup
EOF
        ls -t /ETCD.BACKUP |sed -e '1,14d' | xargs rm -rf
```
