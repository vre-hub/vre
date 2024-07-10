# VRE    

This folder contains the new deployment of the VRE (Jul 2024). Most of the services were re deployed with a newer version, also the k8s cluster running on OpenStack @ CERN. 

The VRE runs on a k8s `v1.29.2-2` cluster with 3 master nodes from 4 (up to 20) workers.

## Flux

Flux `v2.3.0` was installed via [bash](https://fluxcd.io/flux/installation/), (see bellow). To install a specific flux version run, for example,

`curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=v2.0.0-rc.5 bash`

Flux was bootstraped (sync with a repo) manually via:
`flux bootstrap github --owner=vre-hub --repository=vre --branch=main --path=infrastructure/cluster/flux --author-name flux-ops`.

 - To bootstrap the repository you will need to pass a valid [GitHub PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) -   `Settings > Developer settings > Personal access tokens > Tokens (classic)`.
 - After running the above command, a new `deploy-key` will be automatically set up in the repository configuration under the username of the person that run the command.

Manifests inside the path `infrastructure/cluster/flux` will be automatically deployed to the VRE cluster.

Refer to the [official flux docs](https://fluxcd.io/flux/) for information on how to add manifests e. g. helm charts and add kustomizations.
