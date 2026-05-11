[[_TOC_]]
```bash
kubectl exec -it vault-0 -- /bin/sh
```
```bash
vault secrets enable -path=a kv-v2
vault kv put a/b username="db-readonly-username" password="db-secret-password"
vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"
vault policy write internal-app - <<EOF
    path "a/b" {
    capabilities = ["read"]
    }
EOF
vault write auth/kubernetes/role/a \
    bound_service_account_names=a \
    bound_service_account_namespaces=default \
    policies=a \
    ttl=99999h
```
```io
 kubectl create sa a
```
- deployment-orgchart.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: orgchart
  labels:
    app: orgchart
spec:
  selector:
    matchLabels:
      app: orgchart
  replicas: 1
  template:
    metadata:
      annotations:
      labels:
        app: orgchart
    spec:
      serviceAccountName: a
      containers:
        - name: orgchart
          image: jweissig/app:0.0.1
```
```bash
kubectl apply --filename deployment-orgchart.yaml
```
```bash
 kubectl exec \
    $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") \
    --container orgchart -- ls /vault/secrets
```
```yaml
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/role: 'a'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'a/b'
```
```bash
kubectl patch deployment orgchart --patch "$(cat patch-inject-secrets.yaml)"
```
