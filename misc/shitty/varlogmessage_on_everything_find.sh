sshpass -p trtrtrt4 ssh -tt -o StrictHostKeyChecking=no ernie@10.1.24.251 sshpass -p trtrtrt4 ssh -tt 10.1.24.252 "cat /var/log/messages |grep -i --color ${1} "
sshpass -p trtrtrt4 ssh -tt -o StrictHostKeyChecking=no ernie@10.1.24.251 sshpass -p trtrtrt4 ssh -tt 10.1.24.253 "cat /var/log/messages |grep -i --color ${1} "
