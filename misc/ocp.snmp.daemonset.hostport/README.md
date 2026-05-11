[[_TOC_]]
# 介紹
- 利用daemonset和hostport的機制，在ocp的node上佈署snmp
# 修改
- 把code block內容貼在編輯器內
  - `snmpd.conf: |`底下到第二個`EOF`以上都是binary snmp `/etc/snmp/snmpd.conf`的格式，可以直接修改
- snmp community請填入正確的字串
```bash
cat <<EOF | oc apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: snmp
data:
  snmpd.conf: |
    rocommunity public # default # default: able to get MIB enev without community
#   com2sec notConfigUser 111.111.111.11 whats
#   view systemview include .1
#   view systemview include .1.3.6.1.2.1.1
#   view systemview include .1.3.6.1.2.1.25.1.1
#   proc mountd
#   proc ntalkd 4
#   proc sendmail 10 1
#   exec echotest /bin/echo hello world
#   disk / 10000
#   load 12 14 14
EOF
```
# 套用
- 把改後的設定貼在CLI
  - 示意圖
```bash
[bastion ~ ] # cat <<EOF | oc apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: snmp
data:
  snmpd.conf: |
    rocommunity public # default # default: able to get MIB enev without community
#   com2sec notConfigUser 111.111.111.11 whats
#   view systemview include .1
#   view systemview include .1.3.6.1.2.1.1
#   view systemview include .1.3.6.1.2.1.25.1.1
#   proc mountd
#   proc ntalkd 4
#   proc sendmail 10 1
#   exec echotest /bin/echo hello world
#   disk / 10000
#   load 12 14 14
EOF
configmap/snmp unchanged
[bastion ~ ] # 
```
# 重啟
- 類似`systemctl restart snmpd`的效果
```bash
oc patch -n default daemonset snmp -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"redeploy-timestamp\":\"`date +'%s'`\"}}}}}"
```
# 驗證
```bash
snmpwalk -v 2c -c <COMMUNITY_NAME> <IP_OR_HOSTNAME>
```