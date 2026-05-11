        kubectl delete po fluentd kibana elasticsearch --force --grace-period=0 2>/dev/null
        kubectl delete svc fluentd kibana elasticsearch --force --grace-period=0 2>/dev/null
        kubectl delete -f . --force --grace-period=0 2>/dev/null
        kubectl apply -f .
	sleep 40
        kubectl expose pod elasticsearch --type=ClusterIP --port=9200,9300
        kubectl run kibana --image=docker.elastic.co/kibana/kibana:7.15.1 --env=ELASTICSEARCH_HOSTS=http://elasticsearch:9200
        kubectl expose pod kibana --type=LoadBalancer --name=kibana --port=5601
