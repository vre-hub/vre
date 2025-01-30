# VRE EOS deployment

The VRE analysis platform uses EOS storage for various purposes.

## EOS Rucio Storage Element

A Rucuo Storage Element (RSE) is part of the VRE Rucio instance.

This Storage element is also connected to the RUCIO JupyterLab extension, available on most of  the cluster's JupyterHub environments.
Any user connected to the VRE would be able to make use of the extension to access and browse the VRE Data Lake (data accessibility and data discoverability).

## EOS EULAKE instance

### ~~`eos/eulake`~~ `eos/pilot/eulake` configuration

During the summer of 2024, the eulake instance was transferred into the EOS pilot instance. The snippets below have been edited acording to these changes.

> [!IMPORTANT]
> The `eospilot` instance is not configured by default on the CERN OpenStack clusters - in general, they are deployed with `cern-magnum` charts that brings EOS deployments to the cluster. Because `eulake` is a subdirectory within `eospilot`, note that the following snippets are set up to point to the `eospilot/eulake` subdirectory instead to `eospilot`.

 To add the `eospilot` instance to the EOS deployment, patch the `eos-csi-dir-etc-eos` configmap as shown below. No `ssskeytab` is further needed - as `eulake` used to require - `eospilot` uses the commn eos keytab.

```bash
# charts `eosxd-csi-1.3.1` are deployed with k8s clusters v1.29.2 and cern-magnum-0.15.2.
> kubectl -n kube-system patch configmap eos-csi-dir-etc-eos -p '{"data": {"fuse.pilot.conf": "{\"name\": \"pilot\", \"hostport\": \"eospilot.cern.ch\", \"remotemountdir\": \"/eos/pilot/eulake/escape/data/\", \"auth\": {\"ssskeytab\": \"/etc/eos.keytab\"}}"}}'
```
```yaml
# Patch also the following line into the big chunk of the `auto.eos` section below the rest of eos instances
data:
  auto.eos: |
    (...)
    pilot -fstype=eosx,fsname=pilot  :eosxd
    (...)
```

Now you can add this volume on the jupyterHub deployment to access the instance from any jupyter/pod session. On the jupyterHub helm Helm charts add:

```yaml
        extraVolumes:
          - name: eulake-cern-eos-rse 
            hostPath:
              # This is pointing to /eos/pilot/eulake/escape/data, as defined on the eos-csi-dir-etc-eos/configmap  
              path: /var/eos/pilot 
        extraVolumeMounts:
          - name: eulake-cern-eos-rse # mounts the EOS RSE needed for the Rucio JupiterLab extension
            mountPath: /eos/eulake
            mountPropagation: HostToContainer
            readOnly: true 
```

> [!IMPORTANT]
> Please note that within this configuration there are two things happening.
> 1. The propagation of a volume into the cluster (mounting a specific subdirectory of `eospilot`). 
> 2. The user authentication & authorisation to that subdirectory - which is not detailed here, and needs to be done from the eos server side. 
>
> If A&A is not correctly given/propagated, users won't be able to access `/eos/eulake` from their session.
