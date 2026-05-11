[[_TOC_]]
# nfs
- cat /etc/exports
```
/nfs/ *(rw,async,no_root_squash)
```
```
mkdir /nfs/redis{0..5}
```
# redis.conf
- loglevel
   - debug (a lot of information, useful for development/testing)
   - verbose (many rarely useful info, but not a mess like the debug level)
   - notice (moderately verbose, what you want in production probably)
   - warning (only very important / critical messages are logged)
- ports
  - cluster-announce-port # 6379
  - cluster-announce-bus-port # 6380
# k8s
- 部屬6台redis
```
kubectl apply -f pv.yaml
kubectl apply -f . # 部屬目錄下所有yaml。
```
- 建立redis cluster
  - 坑：注意stdout的最後面" :6379"需要忽略。
![](images/redis-cluster/t1.PNG )
```
kubectl get pods -l app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 '
10.0.2.46:6379 10.0.0.185:6379 10.0.2.195:6379 10.0.2.31:6379 10.0.3.144:6379 10.0.2.120:6379 :6379
```
# container
- 進入container執行redis-cli
```
redis-cli --cluster create --cluster-replicas 1 # 後面貼上面那一串stdout
```
# redis-cli
- 在container測驗結果
```
redis-cli
127.0.0.1:6379> cluster nodes
```
- stdout
```
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 10.0.3.144:6379 to 10.0.2.46:6379
Adding replica 10.0.2.120:6379 to 10.0.0.185:6379
Adding replica 10.0.2.31:6379 to 10.0.2.195:6379
M: 61f783900ea75408169a8509c5475be25ae456e5 10.0.2.46:6379
   slots:[0-5460] (5461 slots) master
M: e25480b9986a46f7f11ab7779658058422492a80 10.0.0.185:6379
   slots:[5461-10922] (5462 slots) master
M: 29fc6b0889aa8254410950295ed6d8bf0600af8d 10.0.2.195:6379
   slots:[10923-16383] (5461 slots) master
S: fe96a3178ab9316af956ea38e2a72a159237b279 10.0.2.31:6379
   replicates 29fc6b0889aa8254410950295ed6d8bf0600af8d
S: 480dfeb0e31c821d9977f16c9c298e14a3e82d84 10.0.3.144:6379
   replicates 61f783900ea75408169a8509c5475be25ae456e5
S: 7f4046f27404ff72ac184ace2412898149d70c70 10.0.2.120:6379
   replicates e25480b9986a46f7f11ab7779658058422492a80
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
...
   1 additional replica(s)
M: 29fc6b0889aa8254410950295ed6d8bf0600af8d 10.0.2.195:6379
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: 480dfeb0e31c821d9977f16c9c298e14a3e82d84 10.0.3.144:6379
   slots: (0 slots) slave
   replicates 61f783900ea75408169a8509c5475be25ae456e5
M: e25480b9986a46f7f11ab7779658058422492a80 10.0.0.185:6379
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 7f4046f27404ff72ac184ace2412898149d70c70 10.0.2.120:6379
   slots: (0 slots) slave
   replicates e25480b9986a46f7f11ab7779658058422492a80
S: fe96a3178ab9316af956ea38e2a72a159237b279 10.0.2.31:6379
   slots: (0 slots) slave
   replicates 29fc6b0889aa8254410950295ed6d8bf0600af8d
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
# 測試HA
- 刪除隨意一個pod後再透過cluster nodes的指令來確認新生成的pod IP有沒有自動被加到裡面。
  - 進入container後檢視刪除前cluster nodes的IP
    - 再重新檢視cluster nodes並找出新的IP來確認是否實現HA。
![](images/redis-cluster/e.PNG )
# 測試重建cluster
- 刪除statefulSets
```
kubectl delete -f sts.yaml
```
- 在NFS server手動執行
```
rm /nfs/redis{0..7}/*
```
- 進入container並檢查cluster是否存在
  - 情除nodes.conf後只能看到redis node "myself"的訊息。
```
redis-cli
127.0.0.1:6379> cluster nodes
887080f54fe274106fa8dc3e637f94a9d23df615 10.0.2.35:6379@16379 myself,master - 0 0 0 connected
```
![](images/redis-cluster/f.PNG )
# 連線方式
- k8s cluster內的原件可以透過service name連到redis cluster
![](images/redis-cluster/h.PNG )
- 刪除連線中的redis node(myself那一個)app會到隨意一個redis node
```
kubectl delete pod redis-app-5
```
![](images/redis-cluster/h2.PNG )
# known issues
- [x] 用statefulSets取代deployment，實現HA。
- [x] 修正log volume位置
- [x] /var/lib/redis 需要分別volume出來。
# note
- **pvc seems matched by metadata.name instaed of metadata.labels according to sts/sts.yaml: volumeClaimTemplates.metadata.name**
