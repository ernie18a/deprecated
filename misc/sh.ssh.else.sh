for i in $(cat ./list.b2); do
  echo "Processing $i"
  count=$(ssh -o ConnectTimeout=2 ubuntu@$i ls -l | wc -l)
  echo $i
  if [ $count -gt 80 ]; then
    # Do A
    echo "Performing action A for $i"
    whoami
  else
    # Do B
    echo "Performing action B for $i"
    echo $(whoami)
  fi 
done 
