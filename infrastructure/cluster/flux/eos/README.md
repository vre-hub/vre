# VRE EOS deployment

The VRE analysis platform uses EOS storage for various purposes.

## EOS Rucio Storage Element

A Rucuo Storage Element (RSE) is part of the VRE Rucio instance.

This Storage element is also connected to the RUCIO JupyterLab extension, available on most of  the cluster's JupyterHub environments.
Any user connected to the VRE would be able to make use of the extension to access and browse the VRE Data Lake (data accessibility and data discoverability).

## EOS EULAKE instance

### Configuration

## `eos/eulake` configuration

During the summer of 2024, the eulake instance was moved into the EOS pilot instance. The snippets below have been edited acording to this changes.

The `eulake` instance is not configured by default on the CERN OpenStack clusters - The cluster are deployed with EOS deployments, though. To do so, path the `eosxd` configmap to add the eulake instance into your cluster. Modified the various mount directories as you wish.

Then, add the `eulake` keytab secret as described below. The keytab srcret string can be find on the cern-ver `tbag`.

```bash
# charts `eosxd-csi-1.3.1` are deployed with k8s clusters v1.29.
> kubectl -n kube-system patch configmap eos-csi-dir-etc-eos -p '{"data": {"fuse.eulake.conf": "{\"name\": \"eulake\", \"hostport\": \"eoseulake.cern.ch\", \"remotemountdir\": \"/eos/pilot/eulake/escape/data\", \"localmountdir\": \"/eos/eulake\", \"auth\": {\"ssskeytab\": \"/etc/eos.keytab\"}}"}}'

> kubectl -n kube-system patch secret eos-csi-file-etc-eos-keytab -p '{"stringData": {"fuse.sss.keytab": "<KEYSTAB_SECRET_STRING>"}}'
```

Now you can add this volumes on the jupyter hub deployment to access the instance from any pod or jupyter session. On the jupyter hub helm release

```yaml
        extraVolumes:
          - name: eulake-cern-eos-rse 
            hostPath:
              # This is pointing to /eos/pilot/eulake/escape/data, as defined on the eos-csi-dir-etc-eos/configmap  
              path: /var/eos/eulake 
        extraVolumeMounts:
          - name: eulake-cern-eos-rse # mounts the EOS RSE needed for the Rucio JupiterLab extension
            mountPath: /eos/cern-eos-rse
            mountPropagation: HostToContainer
            readOnly: true 
```

