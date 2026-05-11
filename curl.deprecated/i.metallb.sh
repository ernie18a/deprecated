kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl apply -f - -n kube-system
# helm install metallb metallb/metallb -n kube-system
helm install --version 0.13.12 metallb metallb/metallb -n kube-system
cat << EOF > ipap.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: kube-system
spec:
  addresses:
  - 172.16.169.251-172.16.169.253
EOF
kubectl apply -f ipap.yaml
cat << EOF > l2a.yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: first-l2ad
  namespace: kube-system
EOF
kubectl apply -f l2a.yaml
