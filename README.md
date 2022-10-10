# EOSC Future CERN

EOSC Future CERN Infrastructure Code.

## Setup Documentation

1. Creation of [Key Pair](https://docs.openstack.org/python-openstackclient/pike/cli/command-objects/keypair.html) to use with the cluster, called `eosc-cluster-keypair` and created by `dogosein`.
2. Cluster creation using the following command:

```bash
openstack coe cluster create eosc-cluster \
    --keypair eosc-cluster-keypair \
    --cluster-template kubernetes-1.22.9-1-multi --master-count 3 \
    --merge-labels \
    --labels cern_enabled=true \
    --labels cvmfs_enabled=true \
    --labels cvmfs_storage_driver=true \
    --labels eos_enabled=true \
    --labels monitoring_enabled=true \
    --labels metrics_server_enabled=true \
    --labels ingress_controller=nginx \
    --labels logging_producer=eosc-future \
    --labels logging_installer=helm \
    --labels logging_include_internal=true \
    --labels grafana_admin_passwd=admin \
    --labels keystone_auth_enabled=true \
    --labels auto_scaling_enabled=true --labels min_node_count=3 --labels max_node_count=7 \
    --node-count 5 --flavor m2.2xlarge --master-flavor m2.medium
```
