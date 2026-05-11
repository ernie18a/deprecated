sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.24 show configuration \|display set \|match description \| match ${1} |grep ${1} |awk '{print $3}' >>/tmp/u
cp /tmp/u /tmp/v
sed -i s/ge/\"ge/g /tmp/u
sed -i s/$/\"/g /tmp/u
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.23 show ethernet-switching table interface ${i} ;done < /tmp/v
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.24 show ethernet-switching table interface ${i} ;done < /tmp/v
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.23 show configuration \|display set \|match ${i} ;done < /tmp/u
while read i; do sshpass -p trtrtrt4 ssh -o StrictHostKeyChecking=no ernie@10.1.16.24 show configuration \|display set \|match ${i} ;done < /tmp/u
rm -rf /tmp/[uv]
