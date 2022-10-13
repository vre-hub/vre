# EOSC Future CERN

EOSC Future CERN Infrastructure Code.

## Getting started as a collaborator

1. Clone this repo
2. [Install git-crypt](https://github.com/AGWA/git-crypt/blob/master/INSTALL.md), generate a GPG Key `gpg --full-generate-key`, export the public key `gpg --export --armor $KEY_ID` and send it to one of the collaborators already added to git-crypt
3. After they added you, you should be able to decrypt encrypted files in the repo using `git-crypt unlock`
4. ..

## Setup documentation

The [Key Pair](https://docs.openstack.org/python-openstackclient/pike/cli/command-objects/keypair.html) that was used to setup the cluster is called `eosc-cluster-keypair` and was created by `dogosein`.

The cluster was created by the following command:

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

The *kubeconfig* is stored as a secret [here](secrets/kubeconfig), copy it and then export it to your environment `export KUBECONFIG=config`. The `eosc-cluster-keypair` openstack keypair is stored as a secret [here](secrets/eosc-cluster-keypair.pem). You can directly connect to an instance with `ssh -i eosc-cluster-keypair.pem core@XXX.XXX.XXX.XXX`

## About file encryption

Keys of new collaborators need to be added to git-crypt using `git-crypt add-gpg-user USER_ID`. As a member you need to import their public key to your GPG `gpg --import /path/to/file` (see also *Getting started as a collaborator*).

**All files in within the `secrets` directory will be encrypted by git-crypt. Other secrets stored in this repo should be encrypted by adding them to `.gitattributes` accordingly.**