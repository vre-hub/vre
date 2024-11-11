#!/bin/bash

RAW_SECRETS_TMP_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"
SECRETS_STORE="/root/software/vre/infrastructure/secrets/jhub"
NAMESPACE="jhub"

SECRET_FILE="jhub-vre-iam-secrets.yaml"
SECRET_FULL_PATH=${RAW_SECRETS_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_FILE}


SECRET_FILE="jhub-vre-db.yaml"
SECRET_FULL_PATH=${RAW_SECRETS_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_FILE}


# To create a persistant auth-state for the jhub configuration
SECRET_FILE="jhub-vre-auth-state.yaml"
SECRET_FULL_PATH=${RAW_SECRETS_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_FILE}