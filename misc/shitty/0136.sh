#sshpass -p 3 ssh -o StrictHostKeyChecking=no e@10.1.63.10 -p8080 ${1}
sshpass -p 3 ssh -Xo StrictHostKeyChecking=no e@10.1.63.10 -p22 ${1}
