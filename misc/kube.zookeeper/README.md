[[_TOC_]]
# NFS server
```
mkdir -p /nfs/zk{0..4}/data
# chmod -R 0777 /nfs/zk*
```
# deploy
```
kubectl apply -f pv.yaml
kubectl apply -f zk.yaml
```
# 測試
## zkCli.sh creater 
- 1, 建立集群後在leader zk-2上建立/aaaaaa bbbbb
- 2, 確認/aaaaaa bbbbb 有建立成功
![](images/zookeeper/a2.PNG )
## 刪除兩個container，其中一個為leader。
- 1, 刪除leader和zk-3來測試高可用
- leader 從zk-2變成zk-4
- 2, 還是可以從自動建立的zk-2get的到/aaaaaa bbbbb
![](images/zookeeper/b.PNG )
## 全部container重啟
- 1, 刪除所有zk後再重新佈署
- 2, get的到之前建立的/aaaaaa bbbbb
![](images/zookeeper/c.PNG )
## 透過service開放存取
- 透過隨意container來存存取zookeeper service
![](images/zookeeper/d.PNG )
# note
- [ ] 優化service
