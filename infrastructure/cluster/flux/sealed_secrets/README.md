# Sealaed secrets

Sealed secrets (chart v2.16.0 what brings app version v0.27.0) charts were taken from the [official repository](https://github.com/bitnami-labs/sealed-secrets), installed via flux (using the manifests on this directory) on the vre cluster.

To correctly interact with Flux:
- First create the namespace and apply the helm-repository manifest manually.
- Then you can push the release manufests.