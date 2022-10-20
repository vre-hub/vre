# EOSC Future CERN

EOSC Future CERN Infrastructure Code.

## Getting started as a collaborator

1. Clone this repo
2. [Install git-crypt](https://github.com/AGWA/git-crypt/blob/master/INSTALL.md), generate a GPG Key `gpg --full-generate-key`, export the public key `gpg --export --armor $KEY_ID` and send it to one of the collaborators already added to git-crypt
3. After they added you, you should be able to decrypt encrypted files in the repo using `git-crypt unlock`
4. Install `kubectl`, `terraform`, `helm` and `kubeseal` in order to do all relevant operations on the cluster (refer to Cluster Setup below)

## Repo structure

the repo is designed to be a Monorepo, containing all relevant files to this project. Within the repo files are logically separated as follows:

* IaC (Terraform, Kubernetes) --> divided into environments (in this case only *prod*)
* Other encrypted secrets
* Application files

## Cluster Setup

### Openstack K8s Cluster

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

Node 0 an 1 are labeled as ingress for *nginx*:

```bash
kubectl label node eosc-cluster-kx4fpc7ktdnk-node-0 role=ingress
kubectl label node eosc-cluster-kx4fpc7ktdnk-node-1 role=ingress
```

### Argo CD GitOps

ArgoCD was installed according to the official [documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/):

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
```

The following ingress enables access to the ArgoCD WebUI: [argocd-server-ingress.yml](infrastructure/openstack/production/k8s/argocd-server-ingress.yml)

In order to access Argo CD from the CERN Network its DNS name (ingress host) needs to be added to *landb*:

```bash
openstack server set --property landb-alias=argocd-eosc--load-1- eosc-cluster-kx4fpc7ktdnk-node-0
openstack server set --property landb-alias=argocd-eosc--load-2- eosc-cluster-kx4fpc7ktdnk-node-1
```

### Terraform IaC for openstack

Terraform is located [here](infrastructure/openstack/prod/tf), the configuration stored in the [main.tf](infrastructure/openstack/prod/tf/main.tf) only stores the provider information.
The provider configuration is taken from the environment variables (when you source the OpenStack RC File).

Find the latest docs on this provider [here](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs).

The workflow in short is:

```bash
git pull

terraform init
terraform plan
terraform apply

git commit -m 'tf apply XYZ'
git push
```

**Never leave changes unapplied and always pull/commit to store the correct state for others!**

### Kubernetes secrets management

Sealed-secrets was installed with the following commands:

```bash
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets
```

Create a sealed secret file running the command below:

```bash
kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o [json|yaml] | \
kubeseal \
    --controller-name=sealed-secrets-controller \
    --controller-namespace=kube-system \
    --format yaml > mysealedsecret.[json|yaml]

kubectl create -f mysealedsecret.[json|yaml]
```

### File encryption (other secrets)

Keys of new collaborators need to be added to git-crypt using `git-crypt add-gpg-user USER_ID`. As a member you need to import their public key to your GPG `gpg --import /path/to/file` (see also *Getting started as a collaborator*).

**All files in within the `secrets` directory will be encrypted by git-crypt. Other secrets stored in this repo should be encrypted by adding them to `.gitattributes` accordingly.**