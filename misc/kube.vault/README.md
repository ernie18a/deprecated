```bash
helm install vault hashicorp/vault --set "server.dev.enabled=true" -n default
```
```bash
kubectl exec -it vault-0 -- /bin/sh
```
- mind internal-app
```bash
vault secrets enable -path=a kv-v2
vault kv put a/b username="db-readonly-username" password="db-secret-password"
vault kv get a/b
vault auth enable kubernetes
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
vault policy write a - <<EOF
path "a/b" {
  capabilities = ["read"]
}
EOF
 vault write auth/kubernetes/role/a \
    bound_service_account_names=a \
    bound_service_account_namespaces=default \
    policies=a \
    ttl=9999h
```
```yaml
kubectl create sa a
cat << eof  |tee deployment-issues.yaml | kubectl apply -f -
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
        vault.hashicorp.com/role: 'a'
        vault.hashicorp.com/agent-inject-secret-database-config.txt: 'a/b'
        vault.hashicorp.com/agent-inject-template-database-config.txt: |
          {{- with secret "a/b" -}}
          postgresql://{{ .Data.data.username }}:{{ .Data.data.password }}@postgres:5432/wizard
          {{- end -}}
      labels:
        app: issues
    spec:
      serviceAccountName: a
      containers:
        - name: issues
          image: jweissig/app:0.0.1
eof
```
```bash
kubectl logs \
    $(kubectl get pod -l app=issues -o jsonpath="{.items[0].metadata.name}") \
    --container vault-agent-init
```
```bash
vault write auth/kubernetes/role/offsite-app \
    bound_service_account_names=a \
    bound_service_account_namespaces=offsite \
    policies=a \
    ttl=9999h
```
```yaml
cat << eof | tee patch-issues.yaml | kubectl apply -f -
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
eof
```
```bash
kubectl patch deployment issues --patch "$(cat patch-issues.yaml)"
```
```bash
kubectl exec \
    $(kubectl get pod -l app=issues -o jsonpath="{.items[0].metadata.name}") \
    --container issues -- cat /vault/secrets/database-config.txt; echo
postgresql://db-readonly-user:db-secret-password@postgres:5432/wizard
```
