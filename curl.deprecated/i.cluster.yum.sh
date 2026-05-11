kubeadm config images pull
kubeadm init |tee /tmp/KUBE.INIT
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
curl -fsSL https://gitlab.com/ernie18a/dotfiles/-/raw/main/curl/i.helm.sh | bash
# storageClass
	helm install nfs stable/nfs-server-provisioner -n kube-system
	kubectl patch storageclass nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
helm install cilium cilium/cilium -n kube-system
kubectl patch deployment.apps/cilium-operator -p '{"spec":{"replicas":1}}' -n kube-system
helm install metallb bitnami/metallb -n kube-system
### kubectl patch cm/metallb-config -n kube-system -p '{"date":{"config":1}}'
# cat << EOF2 | kubectl apply -f -
# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: no-provisioner
# provisioner: kubernetes.io/no-provisioner
# volumeBindingMode: Immediate
# # volumeBindingMode: WaitForFirstConsumer
# EOF2
# kubectl patch sc/no-provisioner -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
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
ip a | grep -iE --color "([0-9]{1,3}[\.]){3}[0-9]{1,3}"
