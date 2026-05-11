#!/bin/bash
apt-get install -y transmission-daemon rsync
systemctl stop transmission-daemon.service
mkdir -p /var/lib/transmission-daemon/downloads/.yet
chown debian-transmission:debian-transmission /var/lib/transmission-daemon/downloads/.yet
usermod -aG debian-transmission ubuntu
ln -fs /var/lib/transmission-daemon/downloads ~/.downloads
curl -fsSL https://gitlab.com/ernie18a/misc/-/raw/main/deploy/service.transmission.json > /etc/transmission-daemon/settings.json
systemctl restart transmission-daemon.service 
