# Configure htpasswd Identity Provider
## 1. Creating an HTPasswd file 
*Prerequisites*
- Have access to the htpasswd utility. On Red Hat Enterprise Linux this is available by installing the httpd-tools package.
*Procedure*
1. Create file htpasswd
- Example
```
htpasswd -c -B -b </path/to/users.htpasswd> <user_name> <password>
```
```
htpasswd -c -B -b /root/users.htpasswd admin password123
```

2. Continue to add or update credentials to the file:
```
htpasswd -B -b </path/to/users.htpasswd> <user_name> <password>
```
3. Creating the HTpasswd secret
- example
```
oc create secret generic htpass-secret --from-file=htpasswd=</path/to/users.htpasswd> -n openshift-config
```
```
oc create secret generic htpass-secret --from-file=htpasswd=/root/users.htpasswd -n openshift-config
```

- sample httpasswd custom resource
```
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
```
4. Adding an identity provider to cluster
```
oc apply -f /root/openshift-4.6/users/htpass-admin.yaml
```
5. Login to cluster
```
oc login -u <username>
oc whoami
```
6. Add role to user
- add user to cluster-admin
```
oc adm policy add-cluster-role-to-user cluster-admin admin
```
- add user to spesific project
```
oc adm policy add-role-to-user cluster-admin admin
```

