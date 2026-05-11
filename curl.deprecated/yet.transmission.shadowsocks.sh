echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bash_profile
cd /TRANS
chmod 0777 /TRANS
curl -fsSL https://gitlab.com/ernie18a/misc/-/raw/master/deploying/docker-compose.transmission/docker-compose.yml > /TRANS/docker-compose.yml
docker-compose down ; docker-compose up -d
echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
ln -fs /var/lib/transmission-daemon/downloads ~/.downloads
mkdir /TRANS
sudo apt-get install -y transmission-daemon shadowsocks-libev rsync
sudo bash -c 'cat << EOF > /etc/transmission-daemon/settings.json'
sudo bash -c 'cat <<EOF > /etc/shadowsocks-libev/config.json'
sudo chown debian-transmission:debian-transmission /var/lib/transmission-daemon/downloads/.yet
sudo mkdir -p /var/lib/transmission-daemon/downloads/.yet
sudo reboot
sudo systemctl disable apparmor.service snapd.apparmor.service
sudo systemctl restart shadowsocks-libev.service transmission-daemon.service
sudo systemctl stop shadowsocks-libev.service transmission-daemon.service
sudo usermod -aG debian-transmission ubuntu
