# CERN-VRE cluster

## Cluster administration

The CERN-VRE cluster is composed of 3 master nodes plus 20 worker nodes, running on the CERN OpenStack instance.

 - master nodes: `m2.large` flavour; 4 VCPUs, 7.3 GB RAM and 40 GB.
 - worker nodes: `m2.xlarge` flavour; 8 VCPUs, 14.6 GB RAM and 80 GB.

10 nodes (0 to 9) nodes are "reserved" for infrastructure management; k8s, rucio, jhub, reana ...
10 nodes (10 to 22 - nodes 14, 16 and 21 don't exist) are tagged for computing purposes; jhub-sessions and os, cvmfs and CephFS "connectors". WIP: reana sessions should be spawned here too.

TO date (14 Feb 2024), nodes have been labelled as follows;
`kubectl label node <NODE_NAME>> jupyter=singleuser`

Each Jupyter session is assigned with the following resources (declared on the jhub-release manifest).
Resources have been assigned without much experienced, based on the following 
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
    - Investigate how the `prePuller` config and the `continuous-image-puller` pods can be reduced in a `nodeSelector` way.
 -