# reset
	kubeadm reset -f 2> /dev/null
#	apt-get clean
	dpkg -l | awk '/^rc/ {print $2}' | xargs apt-get purge -y; apt-get purge -y docker* kube* cri* container* apparmor* iptables* firewall* ; apt-get autoremove -y
	rm -rf /etc/apparmor* /opt/cni /etc/docker /var/lib/kubelet /etc/kubernetes /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/trusted.gpg.d/kubernetes.gpg /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list /etc/cni/net.d /etc/containerd/config.toml /etc/docker /etc/firewall* /etc/kube* /etc/sysconfig/iptables /etc/systemd/system/docker* /etc/systemd/system/multi-user.target.wants/kubelet.service /opt/container* /run/cri-dockerd.sock /usr/bin/docker-compose /usr/lib/systemd/system/container-getty@.service /usr/lib/systemd/system/kube* /usr/libexec/docker /usr/libexec/kubernetes /var/lib/container* /var/lib/containerd/io.containerd.runtime.v1.linux /var/lib/cri-dockerd /var/lib/docker* /var/lib/etcd /var/lib/kubelet /var/log/containers /var/log/pods ~/.kube ~/KUBEADM ~/.G/cri-dockerd /etc/systemd/system/*docker* /usr/local/bin/cri-dockerd /etc/apt/keyrings/kube*
	apt-get install -y apt-transport-https ca-certificates curl bsdmainutils # golang
# network
	cat <<EOF | tee /etc/modules-load.d/k8s.conf
	overlay
	br_netfilter
	overlay
	br_netfilter
	ip_vs
	ip_vs_rr
	ip_vs_wrr
	ip_vs_sh
	nf_conntrack
EOF
	cat <<EOF | tee /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-iptables  = 1
	net.bridge.bridge-nf-call-ip6tables = 1
	net.ipv4.ip_forward                 = 1
EOF
	sysctl --system
# docker
	curl -fssL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.docker.sh | bash
# cri-dockerd release
	curl -fsSL https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest |grep -v darwin | grep browser_download_url |grep -i $(dpkg --print-architecture).*tgz | cut -d '"' -f 4 |xargs wget -O /tmp/cri-dockerd.gzip
	tar xf /tmp/cri-dockerd.gzip -C /tmp/ --strip-components=1
	cp /tmp/cri-dockerd /usr/local/bin/cri-dockerd
	chmod 0755 /usr/local/bin/cri-dockerd
# cri-dockerd repo
 	git clone https://github.com/Mirantis/cri-dockerd.git /tmp/go.build.cri-dockerd     
 	cd /tmp/go.build.cri-dockerd
 	install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
	cp -a packaging/systemd/* /etc/systemd/system
	sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
	systemctl daemon-reload
	systemctl enable cri-docker.service
	systemctl enable --now cri-docker.socket
	systemctl restart cri-docker.service
# install kube
	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
	apt-get update
	apt-get install -y kubelet kubeadm kubectl
# bash completion
	kubeadm completion bash > /etc/bash_completion.d/kubeadm
	kubectl completion bash > /etc/bash_completion.d/kubectl
# systemctl
	systemctl daemon-reload
	systemctl enable kubelet docker docker.socket containerd cri-docker.service cri-docker.socket kubelet
	systemctl restart kubelet docker docker.socket containerd cri-docker.service cri-docker.socket kubelet
