# Manual configuration of the `eos/eulake` instance on the CERN - VRE

Any CERN OpenStack cluster comes with an `eos` client and server deployment. 

The version of both components depends on the date the cluster was deployed.

## `eos/eulake` configuration

The `eulake` instance is not configured by default on the CERN OpenStack clusters. To do so, path the `eosxd` configmap to add the isntance into your cluster. Modified the various mount directories as you wish.

Then, add the `eulake` keytab secret as described below. The keytab srcret string can be find on the cern-ver `tbag`.

```bash
> kubectl -n kube-system patch configmap eosxd-config -p '{"data": {"fuse.eulake.conf": "{\"name\": \"eulake\", \"hostport\": \"eoseulake.cern.ch\", \"remotemountdir\": \"/eos/eulake/escape/data\", \"localmountdir\": \"/eos/eulake\", \"auth\": {\"ssskeytab\": \"/etc/eos.keytab\"}}"}}'
> kubectl -n kube-system patch secret eosxd-keytab -p '{"stringData": {"fuse.sss.keytab": "<KEYSTAB_SECRET_STRING>"}}'
```

Now you can add this volumes on the jupyter hub deployment to access the instance from any pod or jupyter session. On the jupyter hub helm release

```yaml
        extraVolumes:
          - name: eulake-cern-eos-rse 
            hostPath:
              # This is pointing to /eos/eulake/escape/data, as defined on the eosxd/configmap  
              path: /var/eos/eulake 
        extraVolumeMounts:
          - name: eulake-cern-eos-rse # mounts the EOS RSE needed for the Rucio JupiterLab extension
            mountPath: /eos/cern-eos-rse
            mountPropagation: HostToContainer
            readOnly: true 
```