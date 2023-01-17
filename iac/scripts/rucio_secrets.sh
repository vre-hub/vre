#!/bin/bash

# Rucio Secret Creation Process
# 1. Create a LanDB Alias for all the required CNAMES like so: openstack server set --property landb-alias=vre-rucio,vre-rucio-auth,vre-rucio-ui <cluster-name>-node-0
# 2. Create and download host certificates form the CERN CA Authority here: https://ca.cern.ch/ca/
# 3. Split them into a cert/key file each by following this documentation: https://ca.cern.ch/ca/Help/?kbid=024010
# 4. Use the below script (modify variabels if needed) to create a SealedSecret for each one of them and deploy them to the cluster

echo "--> create rucio secrets"

controller_ns="shared-services"

helm_release_name_server="rucio-server-cvre"
helm_release_name_ui="rucio-ui-cvre"
helm_release_name_daemons="rucio-daemons-cvre"
# helm_release_name_daemons="vre-rucio-notebook"

SERVERPROXIES="/root/clusters/vre-cluster/rucio-secrets/main/"
AUTHPROXIES="/root/clusters/vre-cluster/rucio-secrets/auth/"
WEBUIPROXIES="/root/clusters/vre-cluster/rucio-secrets/webui/"
# NOTEBOOKPROXIES="/root/clusters/vre-cluster/rucio-secrets/notebook"

# same certificate for the subdomain vre.cern.ch
# SERVERPROXIES="/root/clusters/vre-cluster/rucio-secrets/sectigo/"
# AUTHPROXIES="/root/clusters/vre-cluster/rucio-secrets/sectigo/"
# WEBUIPROXIES="/root/clusters/vre-cluster/rucio-secrets/sectigo/"

# path for .yaml file for secret containing username and password for the ESCAPE Service Account (sso)
DB_PATH="/root/clusters/vre-cluster/rucio-secrets/"

# where to store encrypted secrets
SECRETS_STORE="/root/clusters/vre-cluster/github-eosc/eosc-future-cern/iac/scripts/secrets/"

rucio_namespace="rucio"

yml_output_prefix="ss_"

cp /etc/pki/tls/certs/CERN-bundle.pem /etc/pki/tls/certs/ca.pem

echo "--> create and apply main server secrets"

kubectl create secret generic ${helm_release_name_server}-server-hostcert --dry-run=client --from-file=${SERVERPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-hostcert.yaml

kubectl create secret generic ${helm_release_name_server}-server-hostkey --dry-run=client --from-file=${SERVERPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-hostkey.yaml

kubectl create secret generic ${helm_release_name_server}-server-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-cafile.yaml

# kubectl create secret generic ${helm_release_name_server}-server-cafile --dry-run=client --from-file=${SERVERPROXIES}ca.pem -o yaml | \
# kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-cafile.yaml

# kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-server-cafile.yaml


echo "--> create and apply auth server secrets"

kubectl create secret generic ${helm_release_name_server}-auth-hostcert --dry-run=client --from-file=${AUTHPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-hostcert.yaml

kubectl create secret generic ${helm_release_name_server}-auth-hostkey --dry-run=client --from-file=${AUTHPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-hostkey.yaml

kubectl create secret generic ${helm_release_name_server}-auth-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cafile.yaml

# kubectl create secret generic ${helm_release_name_server}-auth-cafile --dry-run=client --from-file=${AUTHPROXIES}ca.pem -o yaml | \
# kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cafile.yaml

# kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cafile.yaml

echo "--> create and apply ui secrets"

kubectl create secret generic ${helm_release_name_ui}-hostcert --dry-run=client --from-file=${WEBUIPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-hostcert.yaml

kubectl create secret generic ${helm_release_name_ui}-hostkey --dry-run=client --from-file=${WEBUIPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-hostkey.yaml

kubectl apply -f  ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-hostkey.yaml

kubectl create secret generic ${helm_release_name_server}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cafile.yaml

# kubectl create secret generic ${helm_release_name_server}-cafile --dry-run=client --from-file=${WEBUIPROXIES}ca.pem -o yaml | \
# kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cafile.yaml

# kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cafile.yaml

echo "--> create rucio CA bundle for daemons"

bundle_dir="/root/clusters/vre-cluster/rucio-secrets/ca-bundle"
rm -rf ${bundle_dir}
mkdir ${bundle_dir}
cp /etc/grid-security/certificates/*.0 ${bundle_dir}
cp /etc/grid-security/certificates/*.signing_policy ${bundle_dir}

kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle-reaper --from-file=${bundle_dir} -n rucio
kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle --from-file=${bundle_dir} -n rucio

#  TLS secrets fro rucio services 
# kubectl create secret tls vre-rucio-server.tls-secret --key=${SERVERPROXIES}hostkey.pem --cert=${SERVERPROXIES}hostcert.pem -n=rucio 

echo "--> create rucio DB secret"

kubectl -n rucio create secret generic ${helm_release_name_server}-rucio-db --from-literal=dbconnectstring=${DB_CONNECT_STRING} --dry-run=client -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-rucio-db.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-rucio-db.yaml

echo "--> create service account secret for rucio client container to check initial server connection"

cat ${DB_PATH}sso-secret.yaml | kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}-sso-account.yaml
kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}-sso-account.yaml


# Manually creating a copy of the service account secrets for Rucio FTS authentication

cat escape-daemons-fts-cert.yaml | kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ss_rucio-daemons-cvre-fts-cert.yaml
cat escape-daemons-fts-key.yaml | kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ss_rucio-daemons-cvre-fts-key.yaml

kubectl create -f rucio-daemons-cvre-fts-cert.yaml 
kubectl create -f rucio-daemons-cvre-fts-key.yaml


echo "--> create and apply fts secrets"

kubectl create secret generic ${helm_release_name_daemons}-fts-cert --dry-run=client --from-file=usercert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}${helm_release_name_daemons}-fts-cert.yaml

kubectl apply -f ${yml_output_prefix}${helm_release_name_daemons}-fts-cert.yaml

kubectl create secret generic ${helm_release_name_daemons}-fts-key --dry-run=client --from-file=new_userkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}${helm_release_name_daemons}-fts-key.yaml

kubectl apply -f ${yml_output_prefix}${helm_release_name_daemons}-fts-key.yaml