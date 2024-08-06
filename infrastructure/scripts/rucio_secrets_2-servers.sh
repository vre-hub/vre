#!/bin/bash

echo " *** START rucio SERVERS Secret Script"

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_SERVERS="/root/clusters_CERTS/vre/servers"
RAW_SECRETS_SERVERS_AUTH="/root/clusters_CERTS/vre/servers-auth"
RAW_SECRETS_IDP="/root/software/vre/infrastructure/secrets/tmp_local_secrets/idpsecrets.json"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller"

# rucio namespace
RUCIO_NS="rucio"
HELM_RELEASE_SERVER="servers"
HELM_RELEASE_SERVER_AUTH="servers-auth"

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"

echo " *** Create and apply SERVER secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostcert --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostkey --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-hostkey.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-hostkey.yaml

# The content of this file is the same as in /etc/pki/tls/certs/CERN-bundle.pem but renamed to ca.pem
kubectl create secret generic ${HELM_RELEASE_SERVER}-server-cafile --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-cafile.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-cafile.yaml

echo " *** Create and apply SERVER GRID CA secrets"

# Create server secret for the GridCA file
# The content of this file is the same as in /etc/grid-security/certificates/CERN-GridCA.pem but mv'd.
kubectl create secret generic ${HELM_RELEASE_SERVER}-server-gridca --dry-run=client --from-file=${RAW_SECRETS_SERVERS}/CERN-GridCA.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-gridca.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER}-server-gridca.yaml


echo " *** Create and apply SERVER AUTH secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-hostcert --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostcert.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-hostkey --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostkey.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-server-cafile --dry-run=client --from-file=${RAW_SECRETS_SERVERS_AUTH}/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-cafile.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-server-cafile.yaml

echo " *** Create and apply OIDC secrets for SERVER AUTH"

kubectl create secret generic ${HELM_RELEASE_SERVER_AUTH}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP} -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-idpsecrets.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_SERVER_AUTH}-idpsecrets.yaml

echo " *** END rucio SERVERS Secret Script"