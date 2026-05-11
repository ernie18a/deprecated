#!/bin/bash
apt-get install -y shadowsocks-libev rsync rng-tools
systemctl stop shadowsocks-libev.service
# shadowsocks-libev.service 
cat <<EOF > /etc/shadowsocks-libev/config.json
{ "server":"0.0.0.0",
 "server_port":443,
 "local_port":1080,
 "password":"5555555555555555555555555",
 "timeout":60,
 "method":"chacha20-ietf-poly1305"
}
EOF
systemctl restart shadowsocks-libev.service
