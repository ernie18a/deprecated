# docker
	mkdir /etc/docker
	cat <<EOF > /etc/docker/daemon.json
	{
	  "exec-opts": ["native.cgroupdriver=systemd"],
	  "log-driver": "json-file",
	  "log-opts": {
	    "max-size": "100m"
	  },
	  "storage-driver": "overlay2",
	  "storage-opts": [
	    "overlay2.override_kernel_check=true"
	  ]
	}
EOF
	curl -fssL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.docker.sh | bash
# pre-quest
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
# something...
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
kubeadm config images pull
kubeadm init |tee /tmp/KUBE.INIT
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.helm.sh | bash
kubectl taint nodes --all node-role.kubernetes.io/master-
# storageClass
	helm install nfs stable/nfs-server-provisioner -n kube-system
	kubectl patch storageclass nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# kube-state-metrics
	mkdir ~/.G
	cd ~/.G
	git clone https://github.com/kubernetes/kube-state-metrics.git
	cd kube-state-metrics/examples/standard/
	kubectl apply -f .
	cd 
