# default
	kubeadm init --cri-socket unix:///run/containerd/containerd.sock 2>&1 |tee /tmp/KUBE.INIT.$(date +'%m%d%H%M')
	mkdir -p $HOME/.kube
	cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
	curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.helm.sh | bash
	helm install cilium cilium/cilium -n kube-system
# metrics
	curl -fsSL https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml > /tmp/a.yaml
	sed -i '/- args:/a \ \ \ \ \ \ \ \ \- --kubelet-insecure-tls' /tmp/a.yaml
	kubectl apply -f /tmp/a.yaml
# single
	kubectl taint nodes --all node-role.kubernetes.io/control-plane-
## openebs
#	kubectl apply -f https://openebs.github.io/charts/openebs-operator-lite.yaml -f https://openebs.github.io/charts/openebs-lite-sc.yaml
	kubectl apply -f https://openebs.github.io/charts/openebs-operator-lite.yaml
	curl -fsSL https://openebs.github.io/charts/openebs-lite-sc.yaml | sed -e "s/Delete/Retain/" | kubectl apply -f - # -n openebs
	kubectl delete --force --grace-period=0 sc openebs-device
	kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
