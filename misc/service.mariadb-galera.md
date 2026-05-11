[[_TOC_]]
# /etc/my.cnf.d/galera.cnf
```bash
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=ON
wsrep_provider=/usr/lib64/galera-4/libgalera_smm.so
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://192.168.50.11,192.168.50.12,192.168.50.13"
wsrep_sst_method=rsync
wsrep_node_address="192.168.50.11"
wsrep_node_name="Node_1"
```
# misc.
## /var/lib/mysql/grastate.dat
- change safe_to_bootstrap: from 0 to 1 for forcing ```galera_new_cluster``` command.
```bash
# GALERA saved state
version: 2.1
uuid:    85ac5c10-95c3-11eb-a6fc-7246d8bc0a55
seqno:   -1
safe_to_bootstrap: 0
```
# misc
```
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
```
# reference
- https://mariadb.com/downloads/

