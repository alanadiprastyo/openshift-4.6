# Configure Internal Registry 

After installation, you must edit the Image Registry Operator configuration to switch the managementState from **Removed** to **Managed**.

## 1. Configuring registry storage for VMware vSphere
*Prerequisites*
- Cluster administrator permissions.
- A cluster on VMware vSphere
- Persistent storage provisioned for your cluster, such as Red Hat OpenShift Container Storage
**Note**
OpenShift Container Platform supports *ReadWriteOnce* access for image registry storage when you have *only one replica*. To deploy an image registry that supports high availability with *two or more replicas*, **ReadWriteMany** access is required.
- Must have "100Gi" capacity

*Procedure*
1. verify pod registry
```
oc get pod -n openshift-image-registry
```
2. Check registry configuration
```
oc edit configs.imageregistry.operator.openshift.io
...
managementState: Managed
...
```
**Note**
change ManagementState from **Removed** to **Managed**

3. Configuring block registry storage for VMware vSphere
```
oc patch config.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"rolloutStrategy":"Recreate","replicas":1}}'
```
4. Provision the PV for the block storage device, and create a PVC for that volume.
```
oc create -f openshift-4.6/registry/pvc-registry.yaml
```
5. Edit the registry configuration so that it references the correct PVC:
```
oc edit config.imageregistry.operator.openshift.io -o yaml
...
storage:
  pvc:
    claim: image-registry-storage
...
```

6. check clusteroperator status
```
oc get clusteroperator image-registry
```

## 2. Configuring registry storage use NFS Server


