# remove
        kubectl delete po fluentd kibana elasticsearch --force --grace-period=0 2>/dev/null
        kubectl delete svc fluentd kibana elasticsearch --force --grace-period=0 2>/dev/null
# kubectl delete -f
        cd ~/.G/misc/configs/kube.efk &>/dev/null
        kubectl delete -f . --force --grace-period=0 2>/dev/null
        cd - &>/dev/null
# sleep
        sleep 20
# kubectl apply -f
        cd ~/.G/misc/configs/kube.efk &>/dev/null
        kubectl apply -f .
        cd - &>/dev/null
        kubectl expose pod elasticsearch --type=ClusterIP --port=9200,9300
# build
#       kubectl run elasticsearch --image=docker.elastic.co/elasticsearch/elasticsearch:7.15.1 --env=discovery.type=single-node
#       kubectl run fluentd --image=fluent/fluentd:edge
        kubectl run kibana --image=docker.elastic.co/kibana/kibana:7.15.1 --env=ELASTICSEARCH_HOSTS=http://elasticsearch:9200
#       kubectl run metricbeat --image=docker.elastic.co/beats/metricbeat:7.15.1 env=setup.kibana.host=kibana:5601 env=output.elasticsearch.hosts=elasticsearch:9200
# expose
        kubectl expose pod kibana --type=LoadBalancer --name=kibana --port=5601
