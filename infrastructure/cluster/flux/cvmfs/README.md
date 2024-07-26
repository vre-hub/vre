# CVMFS 
## CVMFS on the VRE

CERN OpenStack k8s cluster v1.29.2 is deployed with a `cvmfs StorageClass` provisioned by `cvmfs.csi.cern.ch` and the CVMFS CSI (Container Storage Interface) plugin [link to github repository](https://github.com/cvmfs-contrib/cvmfs-csi). Version `cvmfs-csi-v2.3.2` of the CVMFS charts is installed.

To provision a cvmfs volume within any jupyterhub pod:
* Create a `pvc` making use of the cvms `StorageClass`
* Add an `extraVolumes` and an `extraVolumeMounts` in the [JupyterHub release manifest](../jhub/jhub-release.yaml).

The manifests in this directory will also deploy a pod (`cvmfs-client`) to access cvmfs from the cluster.