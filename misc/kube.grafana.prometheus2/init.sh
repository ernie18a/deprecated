kubectl create deployment --image prom/prometheus prometheus --port=9090
kubectl create deployment --image grafana/grafana grafana --port=3000
kubectl create deployment --image prom/node-exporter node-exporter --port=9100
kubectl run grafana --image=grafana/grafana --port=3000
kubectl run prometheus --image=prom/prometheus --port=9090
kubectl expose pod grafana --type=NodePort
kubectl expose deployment prometheus
kubectl expose deployment grafana --type=LoadBalancer
kubectl expose deployment node-exporter # --type=LoadBalancer
# https://hub.docker.com/r/prom/prometheus
# https://github.com/prometheus/prometheus/blob/main/docs/installation.md
# https://hub.docker.com/r/grafana/grafana
# https://hub.docker.com/r/prom/node-exporter
