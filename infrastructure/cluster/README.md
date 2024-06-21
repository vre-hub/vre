# CERN-VRE cluster

## Cluster administration

The CERN-VRE cluster is composed of 3 master nodes plus 20 worker nodes, running on the CERN OpenStack instance.

 - master nodes: `m2.large` flavour; 4 VCPUs, 7.3 GB RAM and 40 GB.
 - worker nodes: `m2.xlarge` flavour; 8 VCPUs, 14.6 GB RAM and 80 GB.

10 nodes (0 to 9) nodes are "reserved" for infrastructure management; k8s, rucio, jhub, reana ...
10 nodes (10 to 22 - nodes 14, 16 and 21 don't exist) are tagged for computing purposes; jhub-sessions and os, cvmfs and CephFS "connectors". WIP: reana sessions should be spawned here too.

To date (14 Feb 2024), nodes have been labelled as follows;
`kubectl label node <NODE_NAME>> jupyter=singleuser`
and these same 10 nodes need to be tainted to only allow jupyter sessions too
`kubectl taint nodes <NODE_NAME> jupyter=singleuser:NoSchedule`

To date (21 jun 2024), nodes and tains removed. 
Reana was not able to reach cvmfs (ds was not deploying any nodeplugin on the nodes, because of the above restrictions). It was easier to un taint and un label everything, rather than taining all Reana deployment.

Each Jupyter session is therefore spawned within the above nodes (by adding on the jhub-release manifest the `memory`, `nodeSelector` and `extraTolerations`, as showed below).
Resources have been assigned/organised without much experienced, based on the following 
[zero-to-jupyterhub-k8s documentation](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/main/docs/source/administrator/optimization.md#balancing-guaranteed-vs-maximum-memory-and-cpu).

```yaml
singleuser:
#   cpu:
#     limit: 4
#     guarantee: 0.05
  memory:
    # ratio of 3:2 that is lower than the 2:1 suggested (on the above link)
    # This should allow a 
    limit: 4G
    guarantee: 2G

  nodeSelector: 
    jupyter: singleuser        
  extraTolerations:
    - key: jupyter
      operator: Equal
      value: singleuser
      effect: NoSchedule
```

Notes:
 - `cpu` requests have been commented. From the avobe link one can read on point num 3 **If you set resource limits but omit resource requests, then k8s will assume you imply the same resource requests as your limits. No assumptions are made in the other direction.**
 - A ratio of `3.5:3` on `memory` will be set up on the cluster for the ET school happening on the 20 February 2024. To be elaborated / linked with a **leassons learned** post.
 - `nodeSelector` and `extraTolerations` would need to be applied to the `eos` and `cephfs` `Daemonsets` too, so that they are not deployed all along the first 10 nodes.
    - Investigate how the `prePuller` config and the `continuous-image-puller` pods can be reduced in a `nodeSelector` way. --> `Jhub` undestood that the image puller should only be on the nodes assigned for jupyter `:)`. Although there is a `Daemonset` that controls them.
 

 ### Patching the cluster
 #### EOS
`Daemonset` `cern-magnum-eosxd` (`registry.cern.ch/magnum/eosd:4.8.51-1.2`) was deployed by default. The `Daemonset` was patched as follows

```bash
$ kubectl patch ds -n kube-system cern-magnum-eosxd --patch-file node_and_tolerations_jup.yaml
daemonset.apps/cern-magnum-eosxd patched
```
with `cat node_and_tolerations_jup.yaml`
```yaml
spec:
  template:
    spec:
      nodeSelector:
        jupyter: singleuser
      tolerations:
      - effect: NoSchedule
        key: jupyter
        operator: Equal
        value: singleuser
```

**Open doubt** Not sure why the tolerations patch needs to be applied to the whole `ds`, as the `ds` itself it doesn't use these tolerations. However, the pods spawned by, contain both the `nodeSelecter` and the `tolerations`.


 #### CVMFS
`Daemonset` `cvmfs-cvmfs-csi-nodeplugin` () was deployed into the cern-vre (not by default, manually if byt the k8s team, if I recall correctly), and patched as follows

```bash
$ kubectl patch ds -n kube-system cvmfs-cvmfs-csi-nodeplugin --patch-file node_and_tolerations_jup.yaml
daemonset.apps/cvmfs-cvmfs-csi-nodeplugin patched
```

#### CEPHFS 
Done nothing for the moment - not sure if master nodes (or any monitoring) send/connect to CephFS for any reason.
