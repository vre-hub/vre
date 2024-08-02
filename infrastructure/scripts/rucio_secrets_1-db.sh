#!/bin/bash

echo "START rucio DB Secret Script"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller"

# rucio namespace
RUCIO_NS="rucio"

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"
RAW_SECRETS_TMP_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"

echo "Create rucio DB secret"

# name of output secret to apply
DB_OUTPUT_SECRET="rucio-db.yaml"
RAW_DB_FILE_SECRET=${RAW_SECRETS_TMP_DIR}/${DB_OUTPUT_SECRET}

cat ${RAW_DB_FILE_SECRET} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${DB_OUTPUT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${DB_OUTPUT_SECRET}

echo "END rucio DB Secret Script"