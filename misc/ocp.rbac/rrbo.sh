export PN=car
oc create ns $PN
cat <<EOF | envsubst > rrp.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $PN
  namespace: $PN
subjects:
- kind: User
  name: $PN
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: $PN
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $PN
  name: $PN
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
EOF
oc apply -f rrp.yaml
#
htpasswd -c -B -b users.htpasswd $PN $PN
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config 
#
cat <<EOF > oauth.yaml
apiVersion: config.openshift.io/v1
kind: OAuth          
metadata:            
 name: cluster      
spec:                
 identityProviders: 
 - name: htpasswd
   mappingMethod: claim
   type: HTPasswd   
   htpasswd:        
     fileData:      
       name: htpass-secret
EOF
oc apply -f oauth.yaml
rm -rf rrb.yaml
rm -rf oauth.yaml
