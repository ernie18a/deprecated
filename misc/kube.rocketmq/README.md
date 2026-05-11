[[_TOC_]]
# nfs
## nfs-client.yaml
- 修改nfs server IP
## nfs server
- mkdir -p /data/k8s/
- cat /etc/exports
```
/data/k8s/ *(rw,async,no_root_squash)
```
# 佈署
- ls -l
```
drwxr-xr-x 2 root root   87 Feb  7 20:56 cluster
drwxr-xr-x 2 root root 4096 Feb  7 21:09 dependency
-rw-r--r-- 1 root root 2375 Feb  7 20:19 rocketmq_v1alpha1_nameservice_cr.yaml
-rw-r--r-- 1 root root  158 Feb  7 20:26 svc.yaml
```
```
kubectl apply -f dependency
kubectl apply -f .
kubectl apply -f cluster

```
# 測試
- 進入container
## 重啟cluster後topic是否存在
- 查node ip
```
sh mqadmin  clusterList
```
```
#Cluster Name     #Broker Name            #BID  #Addr                  #Version                #InTPS(LOAD)       #OutTPS(LOAD) #PCWait(ms) #Hour #SPACE
broker            broker-0                0     10.0.5.73:10911        V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.1881
broker            broker-0                1     10.0.1.211:10911       V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.2012
broker            broker-1                0     10.0.5.238:10911       V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.1881
broker            broker-1                1     10.0.0.133:10911       V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.2231
broker            broker-2                0     10.0.1.158:10911       V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.2012
broker            broker-2                1     10.0.0.124:10911       V4_5_0                   0.00(0,0ms)         0.00(0,0ms)          0 447972.97 0.2231
```
- 在name-service-0建立topic
- broker-0，BID為0的IP和port
```
sh mqadmin updateTopic  -b 10.0.5.73:10911 -t aaaaaaaaaaaaaaaaaaaaaaaaaaaa
```
- 建立和查看
![](images/rocketmq/a.PNG )
- 重啟
  - 刪除
```
kubectl delete -f cluster
kubectl apply -f .
kubectl delete -f dependency
```
  - 重啟
```
kubectl apply -f dependency
kubectl apply -f .
kubectl apply -f cluster
```
- 在broker-2-replica-1-0查看
```
sh mqadmin topicList
```
![](images/rocketmq/c.PNG )
## 在MQ cluster外存取服務
# note
- 部屬nameServer前、後都需要確認前置作業有執行完成。
- 建立topic腳本
```
sh ./tools.sh org.apache.rocketmq.example.quickstart.Producer
```
