1) Configure iam-config.conf or set up the Environment Variables to point to the correct IAM Server and provide Client ID and Secret.
Instructions on how to configure the IAM clients are in the Wiki of the main `cern-vre` repo. 
2) The Rucio Server should be installed and the DB should be configured before running the script.

```bash
export IAM_SERVER=https://iam-escape.cloud.cnaf.infn.it
export IAM_CLIENT_ID=my_client_id
export IAM_CLIENT_SECRET=my_secret

python sync_iam_rucio.py
```