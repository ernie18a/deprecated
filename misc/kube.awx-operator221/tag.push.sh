# parameters
        CRI=docker
        REGISTRY=172.16.169.246:5000
        HARBOR_PROJECT=awx
# tag
        $CRI tag gcr.io/kubebuilder/kube-rbac-proxy:v0.13.0 $REGISTRY/$HARBOR_PROJECT/kube-rbac-proxy:v0.13.0
        $CRI tag postgres:13 $REGISTRY/$HARBOR_PROJECT/postgres:13
        $CRI tag quay.io/ansible/awx-ee:latest $REGISTRY/$HARBOR_PROJECT/awx-ee:latest
        $CRI tag quay.io/ansible/awx-operator:2.2.1 $REGISTRY/$HARBOR_PROJECT/awx-operator:2.2.1
        $CRI tag quay.io/ansible/awx:22.3.0 $REGISTRY/$HARBOR_PROJECT/awx:22.3.0
        $CRI tag redis:7 $REGISTRY/$HARBOR_PROJECT/redis:7
# push
        $CRI push $REGISTRY/$HARBOR_PROJECT/kube-rbac-proxy:v0.13.0
        $CRI push $REGISTRY/$HARBOR_PROJECT/postgres:13
        $CRI push $REGISTRY/$HARBOR_PROJECT/awx-ee:latest
        $CRI push $REGISTRY/$HARBOR_PROJECT/awx-operator:2.2.1
        $CRI push $REGISTRY/$HARBOR_PROJECT/awx:22.3.0
        $CRI push $REGISTRY/$HARBOR_PROJECT/redis:7
