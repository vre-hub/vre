:construction: *This repository is still under construction*

[![tfsec](https://github.com/EOSC-Future/eosc-future-cern/actions/workflows/tfsec.yml/badge.svg)](https://github.com/EOSC-Future/eosc-future-cern/actions/workflows/tfsec.yml)

# EOSC Future CERN

EOSC Future CERN Infrastructure Code.

## Prerequisites

In order to create or interact with this cluster you'll need: `kubectl`, `terraform`, `helm` and `kubeseal` installed locally.

Further you'll need the Openstack RC configuration and the kubeconfig (once the cluster has been created).

## Repository structure

The repo is designed to be a Monorepo, containing all relevant files to this project:

* `iac`: Infrastructure as Code
    * `scripts`: Scripts used for the infrastructure
    * `tf`: Terraform files
        * `cluster`: Cluster main files
        * `modules`: Terraform modules used in the cluster

## Cluster Setup

### Terraform

All resources are created via [Terraform](https://www.terraform.io/).

:warning: **The openstack terraform provider does not support changes to exisitng resources. Every change will result in a replace operation!**

### Namespaces

| Namespace | Description |
| --- | --- |
| shared-services | Namespace for shared resources |
| rucio | Namespace for rucio resources |
| monitoring | Namespace for monitoring resources |

### Manual configurations

Node 0 an 1 are labeled as ingress for *nginx*:

```bash
kubectl label <node-name> role=ingress
kubectl label <node-name> role=ingress
```

### Kubernetes secrets management

Create a sealed secret file running the command below:

```bash
kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o [json|yaml] | \
kubeseal \
    --controller-name=sealed-secrets-controller \
    --controller-namespace=kube-system \
    --format yaml > mysealedsecret.[json|yaml]

kubectl create -f mysealedsecret.[json|yaml]
```

## Rucio

Some secrets need to be created before applying the Rucio Helm charts via Terraform. A script with instructions can be found [here](code/eosc-future-cern/iac/scripts/create-rucio-secrets.sh). The secrets will be encrypted with sealed-secrets. The CERN Openstack `nginx-ingress-controller` pod in the `kube-system` namespace has a `validatingwebhookconfiguration` named `ingress-nginx-admission` that needs to be deleted in order for the nginx ingress controller to be able to reach the K8s API. 

In order to pass te database connection string to Rucio, we need to export it as a variable. Therefore, run this command locally:
```
$export DB_CONNECT_STRING="<set manually>"
```
