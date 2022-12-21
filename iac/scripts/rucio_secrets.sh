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
DB_PATH="/root/clusters/vre-cluster/rucio-secrets/"
SECRETS_STORE="/root/clusters/vre-cluster/github-eosc/eosc-future-cern/iac/scripts/secrets/"

rucio_namespace="rucio"

yml_output_prefix="ss_"

export DB_CONNECT_STRING="<set manually>" # Maually set the db connect string before running the script

echo "--> create and apply main server secrets"

kubectl create secret generic ${helm_release_name_server}-server-hostcert --dry-run=client --from-file=${SERVERPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-cert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-cert.yaml

kubectl create secret generic ${helm_release_name_server}-server-hostkey --dry-run=client --from-file=${SERVERPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-key.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-key.yaml

kubectl create secret generic ${helm_release_name_server}-server-cafile --dry-run=client --from-file=/etc/pki/tls/certs/CERN-bundle.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-ca.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-main-ca.yaml

echo "--> create and apply auth server secrets"

kubectl create secret generic ${helm_release_name_server}-auth-hostcert --dry-run=client --from-file=${AUTHPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-cert.yaml

kubectl create secret generic ${helm_release_name_server}-auth-hostkey --dry-run=client --from-file=${AUTHPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-key.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-key.yaml

# for tls verification, the files need to be called precisely what the deployment.yaml in the helm-charts of rucio expect

cp /etc/pki/tls/certs/CERN-bundle.pem /etc/pki/tls/certs/ca.pem

kubectl create secret generic ${helm_release_name_server}-auth-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-ca.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-auth-ca.yaml

echo "--> create and apply ui secrets"

kubectl create secret generic ${helm_release_name_ui}-hostcert --dry-run=client --from-file=${WEBUIPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cert.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-cert.yaml

kubectl create secret generic ${helm_release_name_ui}-hostkey --dry-run=client --from-file=${WEBUIPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-key.yaml

kubectl apply -f  ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-key.yaml

kubectl create secret generic ${helm_release_name_server}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/CERN-bundle.pem -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-ca.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_ui}-ca.yaml

echo "--> create rucio CA bundle for daemons"

bundle_dir="/root/clusters/vre-cluster/rucio-secrets/ca-bundle"
rm -rf ${bundle_dir}
mkdir ${bundle_dir}
cp /etc/grid-security/certificates/*.0 ${bundle_dir}
cp /etc/grid-security/certificates/*.signing_policy ${bundle_dir}

kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle-reaper --from-file=${bundle_dir} -n rucio
kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle --from-file=${bundle_dir} -n rucio

#  TLS secrets fro rucio services 
kubectl create secret tls vre-rucio-server.tls-secret --key=${SERVERPROXIES}hostkey.pem --cert=${SERVERPROXIES}hostcert.pem -n=rucio 

# kubectl create secret tls vre-rucio-server.tls-secret --dry-run=client --key=${SERVERPROXIES}hostkey.pem --cert=${SERVERPROXIES}hostcert.pem --namespace=rucio -o yaml | \
# kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-tls.yaml

# kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-tls.yaml

echo "--> create rucio DB secret"

kubectl -n rucio create secret generic ${helm_release_name_server}-rucio-db --from-literal=dbconnectstring=${DB_CONNECT_STRING} --dry-run=client -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-rucio-db.yaml

kubectl apply -f ${SECRETS_STORE}${yml_output_prefix}${helm_release_name_server}-rucio-db.yaml