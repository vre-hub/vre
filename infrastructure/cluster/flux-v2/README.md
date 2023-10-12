# Flux

Flux was installed manually via:
`flux bootstrap github --owner=vre-hub --repository=vre --branch=main --path=infrastructure/cluster/flux-v2 --author-name flux-ops`
with version v2.0.0-rc.5.

Flux version was set to `v2.0.0-rc.5`. Higher flux versions are incompatible with the current cluster version. To install this flux specific version run
`curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=v2.0.0-rc.5 bash`

 - To bootstrap the repository you will need to pass a valid GitHub PAT.
 - After running the above command, a new `deploy-key` will be automatically set up in the repository configuration under the username of the person that run the command.

Manifests inside the path `infrastructure/cluster/flux-v2` will be automatically deployed to the VRE cluster.

Refer to the [official flux docs](https://fluxcd.io/flux/) for information on how to add manifests e. g. helm charts and add kustomizations.
