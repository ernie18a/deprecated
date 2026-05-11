# apt
	apt-get purge -y iptables* ufw* apparmor* firewall*
	apt-get purge -y ; dpkg -l | grep "^rc" | awk "{print\$2}" | xargs sudo apt-get purge -y ; sudo apt-get autoremove -y
	apt-get update ; sudo apt list > .APT
	apt-get install -y tree
	apt-get update # ; apt-get dist-upgrade -y
# env
	echo 'source /dev/stdin <<< "$(curl -Ls https://gitlab.com/ernie18a/dotfiles/-/raw/main/home/.bash_profile)"' >> ~/.bashrc
	echo ServerAliveInterval\ 30 >> /etc/ssh/ssh_config
	echo StrictHostKeyChecking\ no >> /etc/ssh/ssh_config
	echo "e ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
	echo TCPKeepAlive\ yes >> /etc/ssh/ssh_config
	swapoff -a ; sed -i '/swap/ s/^/#/' /etc/fstab
# git @ /home/e
	mkdir ~/.G/
	cd ~/.G/
	git clone https://github.com/tmux-plugins/tpm /home/e/.G/.tmux_plugins_manager
apt-get update && apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common gnupg2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update && apt-get install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli
cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
####
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
systemctl daemon-reload
systemctl restart kubelet
