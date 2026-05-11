#  for i in {0..5} ; do kubectl exec -it redis-app-$i rm /var/lib/redis/* ; done 
#  for i in {0..5} ; do kubectl exec -it redis-app-$i redis-cli --cluster reshard $MY_POD_IP:6379
kubectl exec -it redis-app-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l app=redis-cluster-app -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' |awk  -F\ :6379 "{print\$1}")
