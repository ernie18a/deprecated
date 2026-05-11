kubeadm reset -f
ipvsadm -C 2>/dev/null
yum remove -y docker* kube* cri* container* kubectl docker-ce docker-ce-cli 
yum update -y ; yum install -y iptables-services iproute nfs-utils iproute-tc
ip6tables -F
ip6tables -P FORWARD ACCEPT
ip6tables -P INPUT ACCEPT  
ip6tables -P OUTPUT ACCEPT 
ip6tables -t mangle -F     
ip6tables -t nat -F        
ip6tables -X
iptables -F
iptables -P FORWARD ACCEPT
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t mangle -F
iptables -t nat -F
iptables -X
iptables-save > /etc/sysconfig/iptables
updatedb ; locate rpmsave |xargs rm -rf
rm -rf /etc/kube* ~/.kube /etc/firewall*  /etc/cni/net.d /etc/docker  /var/log/pods /var/log/containers  /usr/libexec/docker /usr/libexec/kubernetes ~/KUBEADM /var/lib/docker*  /var/lib/kubelet  /etc/systemd/system/docker*  /usr/lib/systemd/system/kube* /var/lib/containerd/io.containerd.runtime.v1.linux /opt/container* /var/lib/container* /usr/lib/systemd/system/container-getty@.service /etc/systemd/system/multi-user.target.wants/kubelet.service /var/lib/etcd
# install cri docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo  
yum update -y && yum install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli
mkdir /etc/docker
cat << EOF > /etc/docker/daemon.json
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
mkdir -p /etc/systemd/system/docker.service.d
# install kube
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
update-alternatives --set iptables /usr/sbin/iptables-legacy
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
# MY_KUBE_VERSION=-1.18
# yum install -y kubelet$MY_KUBE_VERSION kubeadm-$MY_KUBE_VERSION kubectl-$MY_KUBE_VERSION --disableexcludes=kubernetes
# MY_KUBE_VERSION=-$1
# yum install -y kubelet$MY_KUBE_VERSION kubeadm$MY_KUBE_VERSION kubectl$MY_KUBE_VERSION --disableexcludes=kubernetes
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
systemctl enable kubelet
systemctl daemon-reload
systemctl daemon-reload
systemctl enable docker
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
kubectl completion bash >/etc/bash_completion.d/kubectl
yum remove -y firewall*
systemctl restart kubelet
systemctl restart docker
