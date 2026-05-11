rm -rf /tmp/w
sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.25 show configuration \|display set \|match description \| match ${1} |grep ${1} |awk '{print $3}' >>/tmp/w
sed -i s/ge/\"ge/g /tmp/w
sed -i s/$/\"/g /tmp/w
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.24 show ethernet-switching table interface ${i} ;done < /tmp/w
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.23 show configuration \|display set \|match ${i} ;done < /tmp/w
