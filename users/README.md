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

## 2. Updating users for an HTPasswd identity provider
1. Retrieve htpasswd file from htpass-secret secret object
```
oc get secret htpass-secret -ojsonpath={.data.htpasswd} -n openshift-config | base64 -d > users.htpasswd
```
2. add or remove user from user.httpasswd
- add a new user
```
htpasswd -bB users.htpasswd <username> <password>
Adding password for user <username>
```
- remove an exisiting user
```
htpasswd -D users.htpasswd <username>
Deleting password for user <username>
```
3. replace the htpass-secret secret object
```
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd --dry-run -o yaml -n openshift-config | oc replace -f -
```
4. if you removed one or more users, you must additionally remove existing resources for each user.
- delete the user object
```
oc delete user <username>
user.user.openshift.io "<username>" deleted
```
- Delete the Identity object for the user:
```
oc delete identity my_htpasswd_provider:<username>
identity.user.openshift.io "my_htpasswd_provider:<username>" deleted
```

