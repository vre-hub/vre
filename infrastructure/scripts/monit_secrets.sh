#!/bin/bash

RAW_SECRETS_TMP_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"
SECRETS_STORE="/root/software/vre/infrastructure/secrets/monit"
NAMESPACE="monit"

SECRET_FILE="monit-escape-vre-tenant.yaml"
SECRET_FULL_PATH=${RAW_SECRETS_TMP_DIR}/${SECRET_FILE}
echo "Creating ${SECRET_FILE} secret"
cat $SECRET_FULL_PATH | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${NAMESPACE} > ${SECRETS_STORE}/ss_${SECRET_FILE}
kubectl apply -f ${SECRETS_STORE}/ss_${SECRET_FILE}
