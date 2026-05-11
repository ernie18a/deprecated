sshpass -p trtrtrt4 ssh -tt -o StrictHostKeyChecking=no ernie@10.1.24.251 sshpass -p trtrtrt4 ssh -tt 10.1.24.252 "cat /etc/dhcp/dhcpd.conf |grep -iv \#host|grep -i --color ${1} "
sshpass -p trtrtrt4 ssh -tt -o StrictHostKeyChecking=no ernie@10.1.24.251 sshpass -p trtrtrt4 ssh -tt 10.1.24.253 "cat /etc/dhcp/dhcpd.d/184.conf |grep -iv \#host|grep -i --color ${1} "
