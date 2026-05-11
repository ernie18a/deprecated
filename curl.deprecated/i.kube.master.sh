kubeadm config images pull
kubeadm init |tee /tmp/KUBE.INIT
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.helm.sh | bash
# storageClass
	helm install nfs stable/nfs-server-provisioner -n kube-system
	kubectl patch storageclass nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
helm install cilium cilium/cilium -n kube-system
helm install metallb bitnami/metallb -n kube-system
### kubectl patch cm/metallb-config -n kube-system -p '{"date":{"config":1}}'
curl -fsSL https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml > /tmp/a.yaml
sed -i '/- args:/a \ \ \ \ \ \ \ \ \- --kubelet-insecure-tls' /tmp/a.yaml
kubectl apply -f /tmp/a.yaml
cat << EOF
data:
  config: |
    address-pools:
    - name: my-ip-space
      protocol: layer2
      addresses:
      - 192.168.1.195-192.168.1.199

kubectl edit cm/metallb-config -n kube-system

EOF
ip a |grep -E ens\|eth\|wlan0 |grep -iE --color "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk "{print\$2}"| awk -F/ "{print\$1}"
