# https://docs.openshift.com/container-platform/4.12/authentication/identity_providers/configuring-htpasswd-identity-provider.html 
htpasswd -c -B -b users.htpasswd cuser cuser
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
#
cat <<EOF > oauth.yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
 name: cluster
spec:
 identityProviders:
 - name: my_htpasswd_provider
   mappingMethod: claim
   type: HTPasswd
   htpasswd:
     fileData:
       name: htpass-secret
EOF
oc apply -f oauth.yaml
