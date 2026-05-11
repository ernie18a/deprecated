curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"| bash 
mv kustomize /bin/
kustomize completion bash > /etc/bash_completion.d/kustomize
