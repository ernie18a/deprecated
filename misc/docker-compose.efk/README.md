[[_TOC_]]
# /etc/security/limits.conf
```io
* hard nofile 65536
* soft nofile 65536
root hard nofile 65536
root soft nofile 65536
```
# /etc/sysctl.conf
```io
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.somaxconn = 1024
net.core.wmem_max = 16777216
net.ipv4.ip_local_port_range = 10240 65535
net.ipv4.tcp_max_syn_backlog = 8096
net.ipv4.tcp_rmem = 4096 12582912 16777216
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_wmem = 4096 12582912 16777216
vm.max_map_count=262144
```
```bash
sysctl -p # reload configs or reboot
```
# /usr/lib/sysctl.d/50-default.conf
- or /etc/sysctl.d/10-link-restrictions.conf
```io
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
```
# commands
```bash
ulimit -u unlimited
# ulimit -n # show status
```
# fluentd -> elasticsearch -> kibana
## fluent.conf
- source: input sources
- match: output destinations
- filter: pipelines
- system: system-wide configuration
- label: group the output and filter for internal routing
- @include: include other files

# misc
- use cat EOF to create above .conf via script
```bash
while : ; do curl -fsSL --connect-timeout 0.000000002 127.0.0.1  1>/dev/null ; done
```
- volume: /usr/share/elasticsearch/config/elasticsearch.yml
- https://docs.fluentd.org/container-deployment/docker-compose
- http://localhost:5601/app/management/kibana/indexPatterns
- http://localhost:5601/app/discover
