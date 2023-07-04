# A few useful scripts useful for operations

- `create_rucio_secrets.sh` creates secrets for Rucio. RUN THIS BEFORE APPLYING RUCIO HELM CHARTS.
- `flux_validate.sh` validates flux-github sync.
- `jhub_screts.sh` generates the jhub secrets present locally.
- `manual-fts-x509up.sh` is deprecated and is done via the [Rucio fts-cron](https://github.com/rucio/containers/tree/master/fts-cron) container. VRE still has an old version of renewing proxies as in `update_rucio_proxies.sh`.
- ` post_cluster_setup.sh` contains indications to set correct URL names after services are up.
- `rucio_daemon_logs.sh` is a script to print all daemon logs for specific file replications for easy debugging.
- `rucio_test_rse_upload.sh` is a script to run locally where you have `gfal` and `voms` installed, to test the upload to all RSEs.
- `ssh-node-root-daemonset.yaml` is a deployment applie dto infra to ssh into a node when in lack of the key file.
- `update_rucio_proxies.sh` is **ESSENTIAL FOR FTS TRANSFERS TO WORK**. It runs on *aiadm* via the acron command

```
acron jobs create -s '0 */8 * * *' -t lxplus.cern.ch -c 'bash /afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/proxies/update_rucio_proxies.sh' -d 'vre-daemons-rucio-x509up secret creation'
```
The Robot certificate associated to the ESCAPE WP2 service account is used to generate a proxy file `x509up` valid for 12 hours. The delegation tells FTS to trust this proxy certificate to perform the transfers. The secrets `pro-rucio-x509up` and `daemons-vre-rucio-x509up` are genrated every 8 hours and the deployment of daemons picks it up every 8 hours (10 minutes after).
