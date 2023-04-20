#/bin/bash
# File to be exectued from this directory

# This script installs the CVMFS CSI driver on a Kubernetes cluster.

helm repo add cern https://registry.cern.ch/chartrepo/cern
helm repo update
helm install cvmfs cern/cvmfs-csi -n kube-system --set-json 'nodeplugin.tolerations=[{"key": "jupyter-role", "operator": "Exists", "effect": "NoSchedule"}]'

# Alternatively, the toleration on the CVMFS nodeplugin DaemonSet to allow the cvmfs plugin be deployed on the same 
#  nodes as the JupyterHub pods will be spawned can be added by hand as a patch: (uncomment the following line)
# kubectl patch daemonset csi-cvmfsplugin -p '{"tolerations": [{"key": "jupyter-role", "operator": "Exists", "effect": "NoSchedule"}]}'

# The CVMFS CSI driver is now installed on the cluster. To use it, you need to create a SC and a PVC

# In case you do not have the SC and the PCV k8s manifest, you can use the following ones:
# ```yaml
# # Based on docs and snippets from https://github.com/cvmfs-contrib/cvmfs-csi
# #
# # Create StorageClass for provisioning CVMFS automount volumes,
# # and a PersistentVolumeClaim that's fulfilled by the StorageClass.
# #
# # If Controller plugin is not deployed, follow the example in volume-pv-pvc.yaml.
# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: cvmfs
# provisioner: cvmfs.csi.cern.ch
# ---
# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: cvmfs
#   namespace: jhub
# spec:
#   accessModes:
#   - ReadOnlyMany
#   resources:
#     requests:
#       # Volume size value has no effect and is ignored
#       # by the driver, but must be non-zero.
#       storage: 1
#   storageClassName: cvmfs
# ```

Kubectl apply -f cvmfs-cs-pvc.yaml
