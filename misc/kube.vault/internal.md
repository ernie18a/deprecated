[[_TOC_]]
```bash
kubectl exec -it vault-0 -- /bin/sh
```
```bash
vault secrets enable -path=internal kv-v2
vault kv put internal/database/config username="db-readonly-username" password="db-secret-password"
vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"
vault policy write internal-app - <<EOF
    path "internal/data/database/config" {
    capabilities = ["read"]
    }
EOF
vault write auth/kubernetes/role/internal-app \
    bound_service_account_names=internal-app \
    bound_service_account_namespaces=default \
    policies=internal-app \
    ttl=99999h
```
```bash
kubectl create sa internal-app
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
      serviceAccountName: internal-app
      containers:
        - name: orgchart
          image: jweissig/app:0.0.1
```
```bash
kubectl apply --filename deployment-orgchart.yaml
```
- patch-inject-secrets.yaml
```yaml
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/role: 'internal-app'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'internal/data/database/config'
```
```bash
kubectl patch deployment orgchart --patch "$(cat patch-inject-secrets.yaml)"
```
```bash
kubectl exec \
    $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") \
    --container orgchart -- cat /vault/secrets/database-config.txt
```
# different namespace
```bas
kubectl create namespace offsite
```
```bash
kubectl config set-context --current --namespace offsite
kubectl create sa internal-app
```
- deployment-issues.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: issues
  labels:
    app: issues
spec:
  selector:
    matchLabels:
      app: issues
  replicas: 1
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/role: 'internal-app'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'internal/data/database/config'
        vault.hashicorp.com/agent-inject-template-database-config.txt: |
          {{- with secret "internal/data/database/config" -}}
          postgresql://{{ .Data.data.username }}:{{ .Data.data.password }}@postgres:5432/wizard
          {{- end -}}
      labels:
        app: issues
    spec:
      serviceAccountName: internal-app
      containers:
        - name: issues
          image: jweissig/app:0.0.1
```
```bash
kubectl apply --filename deployment-issues.yaml
```
```bash
kubectl exec --namespace default -it vault-0 -- /bin/sh
```
```bash
 vault write auth/kubernetes/role/offsite-app \
    bound_service_account_names=internal-app \
    bound_service_account_namespaces=offsite \
    policies=internal-app \
    ttl=24h
```
- patch-issues.yaml
```yaml
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/agent-inject-status: 'update'
        vault.hashicorp.com/role: 'offsite-app'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'internal/data/database/config'
        vault.hashicorp.com/agent-inject-template-database-config.txt: |
          {{- with secret "internal/data/database/config" -}}
          postgresql://{{ .Data.data.username }}:{{ .Data.data.password }}@postgres:5432/wizard
          {{- end -}}
```
```bash
kubectl patch deployment issues --patch "$(cat patch-issues.yaml)"
```
- better specifying pod name
```bash
kubectl exec \
    $(kubectl get pod -l app=issues -o jsonpath="{.items[0].metadata.name}") \
    --container issues -- cat /vault/secrets/database-config.txt; echo
```
- alternative commands
```bash
kubectl exec issues-8c8c7dbdc-47vrp -n offsite --container issues -- cat /vault/secrets/database-config.txt
```
