# Manual configuration of CVMFS on the CERN - VRE

Any CERN OpenStack cluster comes with a CVMFS deployment.

The version of the [`CVMFS CSI` drivers](https://github.com/cvmfs-contrib/cvmfs-csi) depends on the `k8s` cluster and the `magnum` version used (contact the k8s team for details on these versions).

## Instalation of `CVMFS-CSI` on the CERN - VRE

### k8s cluster with `CVMFS-CSI` v2

Version 2 of the drivers should be available on any cluster created later than October 2022.

If `cvfms` is already on the cluster, apply the following manifests.

```bash
kubectl apply -f cvmfs-sc-pvc.yaml
```
with `cvmfs-sc-pvc.yaml`;
```yaml
# cvmfs-sc-pvc.yaml file
# 
# Based on docs and snippets from https://github.com/cvmfs-contrib/cvmfs-csi
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cvmfs
provisioner: cvmfs.csi.cern.ch
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cvmfs
  namespace: jhub
spec:
  accessModes:
  - ReadOnlyMany
  resources:
    requests:
      # Volume size value has no effect and is ignored
      # by the driver, but must be non-zero.
      storage: 1
  storageClassName: cvmfs
```

### `CVMFS-CSI` upgrade from v1 to v2

The following code snippets are derived from the `CVMFS-CSI` [repository](https://github.com/cvmfs-contrib/cvmfs-csi). 
To upgrade the CSI from v1 to v2, please follow the instructions in this [link](https://github.com/cvmfs-contrib/cvmfs-csi/blob/master/docs/upgrading-v1-to-v2-helm.md).

In case you want to deploy from zero v2:

```bash
# helm cli installed is necessary
$ helm repo add cern https://registry.cern.ch/chartrepo/cern
$ helm repo update
$ helm install cvmfs cern/cvmfs-csi -n kube-system --set-json 'nodeplugin.tolerations=[{"key": "jupyter-role", "operator": "Exists", "effect": "NoSchedule"}]'
```

If you are also deploying JupyterHub in the cluster, please note that the k8s tolerations are needed to be able to deploy the `cvmfs-nodeplugin` pods on the same nodes where the jupyter hub will spawn the `jupyter-<user>` nodes.

Alternatively, the toleration can be added by hand as a patch
```bash
# helm cli installed is necessary
$ helm install cvmfs cern/cvmfs-csi -n <namespace> 
$ kubectl patch daemonset csi-cvmfsplugin -p '{"tolerations": [{"key": "jupyter-role", "operator": "Exists", "effect": "NoSchedule"}]}'
```

