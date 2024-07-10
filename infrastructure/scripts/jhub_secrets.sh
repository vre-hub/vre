#!/bin/bash

RAW_SECRETS_TMP_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"
SECRETS_STORE="/root/software/vre/infrastructure/secrets/jhub"
NAMESPACE="jhub"

SECRET_NAME="jhub-vre-iam-secrets.yaml"
SECRET_FILE=${RAW_SECRETS_TMP_DIR}/${SECRET_NAME}
echo "Creating ${SECRET_NAME} secret"
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_NAME}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_NAME}


SECRET_NAME="jhub-vre-db.yaml"
SECRET_FILE=${RAW_SECRETS_TMP_DIR}/${SECRET_NAME}
echo "Creating ${SECRET_NAME} secret"
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_NAME}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_NAME}
