RELEASENAMESERVER="eosc-servers"
RELEASENAMEUI="eosc-webui"
RELEASENAMEDAEMONS="eosc-daemons"
RELEASENAMENOTEBOOK="eosc-notebook"

SERVERPROXIES="/root/clusters/eosc-cluster/certs_as_secrets/main/"
AUTHPROXIES="/root/clusters/eosc-cluster/certs_as_secrets/auth/"
WEBUIPROXIES="/root/clusters/eosc-cluster/certs_as_secrets/webui/"
NOTEBOOKPROXIES="/root/clusters/eosc-cluster/certs_as_secrets/notebook/"

echo "Creating " ${RELEASENAMESERVER}-server secrets 

kubectl create secret generic ${RELEASENAMESERVER}-server-hostcert --from-file=${SERVERPROXIES}/hostcert.pem -n rucio
kubectl create secret generic ${RELEASENAMESERVER}-server-hostkey --from-file=${SERVERPROXIES}/hostkey.pem -n rucio
# if you are on CERN machines, this path is already available, and it will be the same for all the CA-related following secrets 
kubectl create secret generic ${RELEASENAMESERVER}-server-cafile --from-file=/etc/pki/tls/certs/CERN-bundle.pem -n rucio

echo "Creating " ${RELEASENAMESERVER}-auth secrets

kubectl create secret generic ${RELEASENAMESERVER}-auth-hostcert --from-file=${AUTHPROXIES}/hostcert.pem -n rucio
kubectl create secret generic ${RELEASENAMESERVER}-auth-hostkey --from-file=${AUTHPROXIES}/hostkey.pem -n rucio
kubectl create secret generic ${RELEASENAMESERVER}-auth-cafile --from-file=/etc/pki/tls/certs/CERN-bundle.pem -n rucio

# to use HTTPS with an ingress, let the ingress controller handle the TLS connection and then pass the requests using plain HTTP inside the cluster

echo "Creating TLS" secret

kubectl create secret tls eosc-rucio.tls-secret --key=${SERVERPROXIES}/hostkey.pem --cert=${SERVERPROXIES}/hostcert.pem -n rucio

echo "Creating " ${RELEASENAMEUI} secret

kubectl create secret generic ${RELEASENAMEUI}-hostcert --from-file=${WEBUIPROXIES}hostcert.pem -n rucio
kubectl create secret generic ${RELEASENAMEUI}-hostkey --from-file=${WEBUIPROXIES}hostkey.pem -n rucio
kubectl create secret generic ${RELEASENAMESERVER}-cafile --from-file=/etc/pki/tls/certs/CERN-bundle.pem -n rucio

echo "Creating " ${RELEASENAMEDAEMONS}-rucio-ca-bundle secret

kubectl create secret generic ${RELEASENAMEDAEMONS}-rucio-ca-bundle --from-file=/etc/pki/tls/certs/CERN-bundle.pem -n rucio

echo "Creating " ${RELEASENAMEDAEMONS}-rucio-ca-bundle-reaper secret

export CERTDIR=${HOMEPATH}/tmp/reaper-certs/
mkdir ${CERTDIR}
cp /etc/grid-security/certificates/*.0 ${CERTDIR}
cp /etc/grid-security/certificates/*.signing_policy ${CERTDIR}
kubectl create secret generic ${RELEASENAMEDAEMONS}-rucio-ca-bundle-reaper --from-file=${CERTDIR} -n rucio

# optional for jupyterhub: 
echo "Creating " ${RELEASENAMENOTEBOOK} secret
kubectl create secret generic ${RELEASENAMENOTEBOOK}-hostcert --from-file=${NOTEBOOKPROXIES}/hostcert.pem -n rucio
kubectl create secret generic ${RELEASENAMENOTEBOOK}-hostkey --from-file=${NOTEBOOKPROXIES}/hostkey.pem -n rucio

# Needed for daemons:
# 1. X509 robot certificate for the 'rucio-x509up' secret is on my aiadm

# OTHER secrets to be configured from [gitlab](https://gitlab.cern.ch/escape-wp2/flux-rucio/-/tree/master/secrets)
# 2. idpsecrets.json --> oidc secrets for rucio client, look at http://rucio.cern.ch/documentation/installing_server/#server-configuration-for-open-id-connect-authnz and to https://gitlab.com/ska-telescope/src/ska-rucio-prototype/-/blob/master/notes/enable-tokens-1.26.2.md
# 3. hermes-secret --> messenger secret
# 4. db-secret --> database secret
# 5. rse-account --> for S3 cloud storage config

# Doubtful about from [ams](https://github.com/bjwhite-fnal/rucio-ams/blob/master/rucio-ams/helm/helm_scripts/create_cert_secrets.sh)
# FTS secrets (fts-cert and fts-key) 
# ssl-secrets for hermes to autenticate with ActiveMQ --probably not needed at CERN 
