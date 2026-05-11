docker run --rm --net="host" docker.elastic.co/beats/metricbeat:7.15.2 setup --dashboards -e \
  -E output.logstash.enabled=false \
  -E output.elasticsearch.hosts=['192.168.50.138:9200'] \
  -E output.elasticsearch.username=elastic \
  -E output.elasticsearch.password=changeme \
  -E setup.kibana.host=192.168.50.136:5601
