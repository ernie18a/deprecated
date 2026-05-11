- server
```
mkfs.xfs /dev/sdc
mkdir /gluster
mount /dev/sdc  /gluster
gluster volume create vn 172.0.10.174:/gluster/gvb
gluster volume start vn
gluster volume info
```
- client
```
mkdir /gluster
YI glusterfs-fuse
mount -t glusterfs 172.0.10.174:vn /gluster/
```
- test on client
```
touch /gluster/$HOSTNAME
ll /gluster/
```
