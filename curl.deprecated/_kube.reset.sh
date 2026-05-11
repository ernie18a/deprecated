# pre-request
	modprobe -- ip_vs
	modprobe -- ip_vs_rr
	modprobe -- ip_vs_wrr
	modprobe -- ip_vs_sh
	modprobe -- nf_conntrack
	modprobe br_netfilter
	apt-get install -y apt-transport-https ca-certificates curl bsdmainutils
# network
	cat <<EOF | tee /etc/modules-load.d/k8s.conf
	overlay
	br_netfilter
EOF
	cat <<EOF | tee /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-iptables  = 1
	net.bridge.bridge-nf-call-ip6tables = 1
	net.ipv4.ip_forward                 = 1
EOF
	sysctl --system
# install kube
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg
#	curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
	echo "deb [signed-by=/etc/apt/trusted.gpg.d/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

	apt-get update
	apt-get install -y kubelet kubeadm kubectl
# bash completion
	kubeadm completion bash > /etc/bash_completion.d/kubeadm
	kubectl completion bash > /etc/bash_completion.d/kubectl
# systemctl
	systemctl daemon-reload
	systemctl enable kubelet containerd kubelet
	systemctl restart kubelet containerd kubelet
