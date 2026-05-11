#!/bin/bash
sudo apt-get install -y transmission-daemon shadowsocks-libev rsync
sudo systemctl disable apparmor.service snapd.apparmor.service
# sudo apt install snapd -y ; sudo snap install oracle-cloud-agent --classic
sudo systemctl stop shadowsocks-libev.service transmission-daemon.service
sudo mkdir -p /var/lib/transmission-daemon/downloads/.yet
sudo chown debian-transmission:debian-transmission /var/lib/transmission-daemon/downloads/.yet
sudo usermod -aG debian-transmission ubuntu
ln -fs /var/lib/transmission-daemon/downloads ~/.downloads
# transmission-daemon.service
sudo bash -c 'cat << EOF > /etc/transmission-daemon/settings.json'
{
"alt-speed-down": 50,
"alt-speed-enabled": false,
"alt-speed-time-begin": 540,
"alt-speed-time-day": 127,
"alt-speed-time-enabled": false,
"alt-speed-time-end": 1020,
"alt-speed-up": 50,
"bind-address-ipv4": "0.0.0.0",
"bind-address-ipv6": "::",
"blocklist-enabled": false,
"blocklist-url": "http://www.example.com/blocklist",
"cache-size-mb": 4,
"dht-enabled": true,
"download-dir": "/var/lib/transmission-daemon/downloads",
"download-limit": 1000,
"download-limit-enabled": 0,
"download-queue-enabled": true,
"download-queue-size": 50,
"encryption": 1,
"idle-seeding-limit": 30,
"idle-seeding-limit-enabled": false,
"incomplete-dir": "/var/lib/transmission-daemon/downloads/.yet",
"incomplete-dir-enabled": true,
"lpd-enabled": true,
"max-peers-global": 2000,
"message-level": 1,
"peer-congestion-algorithm": "",
"peer-id-ttl-hours": 6,
"peer-limit-global": 2000,
"peer-limit-per-torrent": 500,
"peer-port": 41413,
"peer-port-random-high": 65535,
"peer-port-random-low": 49152,
"peer-port-random-on-start": false,
"peer-socket-tos": "default",
"pex-enabled": true,
"port-forwarding-enabled": false,
"preallocation": 1,
"prefetch-enabled": true,
"queue-stalled-enabled": true,
"queue-stalled-minutes": 30,
"ratio-limit": 2,
"ratio-limit-enabled": false,
"rename-partial-files": true,
"rpc-authentication-required": true,
"rpc-bind-address": "0.0.0.0",
"rpc-enabled": true,
"rpc-host-whitelist": "",
"rpc-host-whitelist-enabled": true,
"rpc-password": "{74be87af056316a9a2d4ad8849184cab102d1c6084Gj0sDY",
"rpc-port": 8091,
"rpc-url": "/transmission/",
"rpc-username": "e",
"rpc-whitelist": "127.0.0.1",
"rpc-whitelist-enabled": false,
"scrape-paused-torrents-enabled": true,
"script-torrent-done-enabled": false,
"script-torrent-done-filename": "",
"seed-queue-enabled": false,
"seed-queue-size": 10,
"speed-limit-down": 100,
"speed-limit-down-enabled": false,
"speed-limit-up": 100,
"speed-limit-up-enabled": false,
"start-added-torrents": true,
"trash-original-torrent-files": false,
"umask": 2,
"upload-limit": 1000,
"upload-limit-enabled": 0,
"upload-slots-per-torrent": 140,
"utp-enabled": true
}
EOF
# shadowsocks-libev.service 
sudo bash -c 'cat <<EOF > /etc/shadowsocks-libev/config.json'
{ "server":"0.0.0.0",
 "server_port":443,
 "local_port":1080,
 "password":"5555555555555555555555555",
 "timeout":60,
 "method":"chacha20-ietf-poly1305"
}
EOF
sudo systemctl restart shadowsocks-libev.service transmission-daemon.service
sudo reboot
# env
# curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bash_profile
echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
# curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.vimrc -o ~/.vimrc
