# Flux

Flux was installed manually via: `flux bootstrap github --owner=vre-hub --repository=vre --branch=main --path=infrastructure/cluster/flux --author-name flux-ops` with version v2.0.0-rc.5. 

Manifests inside the path `infrastructure/cluster/flux-v2` will be automatically deployed to the VRE cluster.

Refer to the [official flux docs](https://fluxcd.io/flux/) for information on how to add manifests e. g. helm charts and add kustomizations.
