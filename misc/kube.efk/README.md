[[_TOC_]]
# deploying
```bash
git clone https://gitlab.com/ernie18a/misc.git
cd misc/deploying/kube.efk
bash build.sh
```
# metricbeat-kubernetes.yaml
  - pre-quest: kube-state-metrics
    - https://github.com/kubernetes/kube-state-metrics#kubernetes-deployment
  - https://www.elastic.co/guide/en/beats/metricbeat/current/running-on-kubernetes.html
# kubernetes-event-exporter
  - https://github.com/opsgenie/kubernetes-event-exporter#elasticsearch
```bash
git clone https://github.com/opsgenie/kubernetes-event-exporter#elasticsearch
cd kubernetes-event-exporter/deploy
grep -rl "namespace: monitoring" |xargs sed  -i 's/namespace: monitoring/namespace: default/g'
```
- vim 01-config.yaml
  - past content from https://github.com/opsgenie/kubernetes-event-exporter#elasticsearch
  - edit content in 01-config.yaml boolean
- note
  - i've enabled plugin systemd
  - i've changed logstash to fluentd in some cm
