[[_TOC_]]
- Some apps do DNS lookups only once and cache the results indefinitely.
# something...
## rs
- blockOwnerDeletion: true
## probes
### livenessProbe
- Indicates whether the container is running. If the liveness probe fails, the kubelet kills the container, and the container is subjected to its restart policy. If a Container does not provide a liveness probe, the default state is Success.
### readinessProbe
- Indicates whether the container is ready to respond to requests. If the readiness probe fails, the endpoints controller removes the Pod's IP address from the endpoints of all Services that match the Pod. The default state of readiness before the initial delay is Failure. If a Container does not provide a readiness probe, the default state is Success.
### startupProbe
- Indicates whether the application within the container is started. All other probes are disabled if a startup probe is provided, until it succeeds. If the startup probe fails, the kubelet kills the container, and the container is subjected to its restart policy. If a Container does not provide a startup probe, the default state is Success.
## StorageClass
-  reclaimPolicy of a StorageClass is immutable, you cannot directly patch it
  - kubectl replace -f sc.yaml --force
### volumeClaimTemplates
- volumeMounts - name > name - volumeClaimTemplates - storageClassName > storageClassName - pv
- When a default StorageClass exists and a user creates a PersistentVolumeClaim without a storage-class annotation, the new DefaultStorageClass admission controller (also introduced in v1.4), automatically adds the class annotation pointing to the default storage class. (2016)
### volumeBindingMode
- ref: https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode
#### WaitForFirstConsumer
- delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.
- 当 PVC 被 Pod 使用时，才触发 PV 和后端存储的创建
- PV will remain unbound until there is a Pod to consume it.
- PersistentVolumes will be selected or provisioned conforming to the topology that is specified by the Pod's scheduling constraints. These include, but are not limited to, resource requirements, node selectors, pod affinity and anti-affinity, and taints and tolerations.
#### Immediate
- default
- volume binding and dynamic provisioning occurs once the PersistentVolumeClaim is created.
- 创建 PVC 后立即创建后端存储卷，并且立即绑定新创建的 PV 和 PVC。
- allow the PV to be bound immediately without requiring to create a Pod.
- For storage backends that are topology-constrained and not globally accessible from all Nodes in the cluster, PersistentVolumes will be bound or provisioned without knowledge of the Pod's scheduling requirements. This may result in unschedulable Pods.
## ClusterRole vs Role
- role
  - A Role can only be used to grant access to resources within a single namespace.
- ClusterRole 
  - A ClusterRole can be used to grant the same permissions as a Role, but because they are cluster-scoped, they can also be used to grant access to:
# + kube cluster user
## kubectl create
```bash
KUBE_USER=bernie
kubectl create sa $KUBE_USER
kubectl create clusterrole $KUBE_USER --verb=get,list,watch --resource=po,deploy,rs,svc,sc,pv,pvc,ing,secret
kubectl create clusterrolebinding $KUBE_USER --serviceaccount=default:$KUBE_USER --clusterrole=$KUBE_USER
```
```yaml
cat<<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: $KUBE_USER
  annotations:
    kubernetes.io/service-account.name: $KUBE_USER
EOF
```
## set-context
```bash
CTX=ctx
TOKEN=$(KD secret $(kubectl describe serviceaccount $KUBE_USER |G Tokens: |AWK 2 ) |G token: |AWK 2)
kubectl config set-credentials $KUBE_USER --token=$TOKEN
kubectl config set-context $CTX --cluster=$(kubectl config current-context |AWK 2 -F@) --user=$KUBE_USER
```
## + linux user
```bash
KUBE_USER=bernie
PW=pw
useradd $KUBE_USER -ms/bin/bash
echo $KUBE_USER:$PW | chpasswd
mkdir /home/$KUBE_USER/.kube
cp ~/.kube/config /home/$KUBE_USER/.kube/
chown -R $KUBE_USER:$KUBE_USER /home/$KUBE_USER
```
## ssh KUBE_USER@KUBE_BASTION
```bash
ssh $KUBE_USER@KUBE_BASTION
```
## use-context
```bash
CTX=podreader
kubectl config use-context $CTX
```
## verify
```bash
kubectl auth can-i get pods --all-namespaces
# yes
kubectl auth can-i create pods
# no
kubectl auth can-i delete pods
# no
```
## note
- https://stackoverflow.com/questions/44948483/create-user-in-kubernetes-for-kubectl
- https://zhuanlan.zhihu.com/p/519754887 # *importante*
- cp .kube/config then kubectl config set-..., so context r able to append in .kube/config
# label
- The two label methods you mentioned are different in terms of their specificity and their potential impact on Kubernetes behavior.

- node-role.kubernetes.io/infra= is a label that is specifically used to indicate that a node in a Kubernetes cluster is designated as an infrastructure node. This label is part of the Kubernetes Node Role feature, which allows cluster administrators to assign roles to nodes based on their intended use. By assigning the "infra" role to certain nodes, administrators can ensure that those nodes are not used for running workloads that are critical to the functioning of the cluster, such as control plane components or storage services.

- node-role.kubernetes.io=infra is a more general label that could be used to indicate that a node has some kind of role related to infrastructure, but it does not specify exactly what that role is. This label does not have any special meaning within Kubernetes itself, so its impact on the behavior of the cluster would depend entirely on how it is used by the cluster administrator or any tools that interact with the cluster.
# mapping registry.k8s.io image to private registry
- https://www.phind.com/search?cache=30261cd2-3e05-4a24-8080-6d3614f10f6d
# IPVS
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
lsmod | grep -e ip_vs -e nf_conntrack_ipv4
export KUBE_PROXY_MODE=ipvs
apt-get update && apt-get install -y ipset

