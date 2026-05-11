[[_TOC_]]
# nfs 
```
mkdir /nfs/mq{0..2}
```
# 佈署
```
kubectl apply -f pv.yaml
kubectl apply -f cm.yaml
kubectl apply -f .
```
# 測試
## 實現HA
- 刪除隨意container後，新container是否重新加回。
![](images/mq/c.PNG )
## 透過service連到cluster。
- 用隨意一台非rabbitMQ container連到rabbitmq的service 5672 port
  - 出現AMQP的字串。
![](images/mq/b.PNG )
```
telnet rabbitmq 5672
AMQP    Connection closed by foreign host.
```
## 全部重新佈署後之前加的queue還存在。
- 透過管理畫面建立queue，刪除全部container並重建後資料還存在。
![](images/mq/a.PNG )
# known issues
- rolling update時web短暫開不了。
