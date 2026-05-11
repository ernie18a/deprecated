for CLIENT in $(cat ./$1); do
        COUNT=$(ssh -o ConnectTimeout=2 ubuntu@$CLIENT ls -l | wc -l)
        echo -e "\n$CLIENT"
        sudo rm -rf /tmp/{$CLIENT.tar,$CLIENT}
        ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo rm -rf /tmp/{$CLIENT.tar,$CLIENT}
        ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo journalctl --vacuum-size=00.1K
        ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo find ~ -type d -name *-bk -exec sudo rm -rf {} +
        if [ $COUNT -gt 80 ]; then
                ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo tar --exclude='*/' -cf /tmp/$CLIENT.tar  ~/$CLIENT || echo $CLIENT\ failed
        else
                ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo tar --exclude='*/' -cf /tmp/$CLIENT.tar ~/{a,b,c} || echo $CLIENT\ failed
        fi
        ssh -o ConnectTimeout=2 ubuntu@$CLIENT sudo chown ubuntu: /tmp/$CLIENT.tar
        scp -o ConnectTimeout=2 ubuntu@$CLIENT:/tmp/$CLIENT.tar /tmp/
        mkdir ~/$CLIENT
        tar -xf /tmp/$CLIENT.tar --strip-components=2 -C ~/$CLIENT/
        sudo chown -R ubuntu:ubuntu ~/$CLIENT
        sudo find ~ -type d -name project -exec chown -R www-data:www-data {} + 
        sudo rm -rf /tmp/{$CLIENT.tar,$CLIENT}
        ssh -o ConnectTimeout=2 -i ubuntu@$CLIENT sudo rm -rf /tmp/{$CLIENT.tar,$CLIENT}
done
