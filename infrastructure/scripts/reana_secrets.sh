##!/bin/bash

echo "Start REANA secrets scripts"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller"

# REANA namespace
REANA_NS="reana"

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/reana"
RAW_SECRETS_TMP_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"


echo "Create REANA DB secret"

DB_OUTPUT_SECRET="reana-db.yaml"
RAW_DB_FILE_SECRET=${RAW_SECRETS_TMP_DIR}/${DB_OUTPUT_SECRET}

cat ${RAW_DB_FILE_SECRET} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${REANA_NS} > ${SECRETS_DIR}/ss_${DB_OUTPUT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${DB_OUTPUT_SECRET}


echo "Create REANA Admin Access Token secret"

ADMIN_ACCOUNT_SECRET='reana-admin-access-token.yaml'
RAW_ADMIN_FILE_SECRET=${RAW_SECRETS_TMP_DIR}/${ADMIN_ACCOUNT_SECRET}

cat ${RAW_ADMIN_FILE_SECRET} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${REANA_NS} > ${SECRETS_DIR}/ss_${ADMIN_ACCOUNT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${ADMIN_ACCOUNT_SECRET}


echo "Create REANA IAM client credentials"

REANA_IAM_ACCOUNT_SECRET='reana-vre-iam-client.yaml'
RAW_REANA_IAM_FILE_SECRET=${RAW_SECRETS_TMP_DIR}/${REANA_IAM_ACCOUNT_SECRET}

cat ${RAW_REANA_IAM_FILE_SECRET} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${REANA_NS} > ${SECRETS_DIR}/ss_${REANA_IAM_ACCOUNT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${REANA_IAM_ACCOUNT_SECRET}


# echo "Create 'REANA secrets' secret"
# # This secret is unknow for what is used - no doc :harold:
# # Kept commented for the moment

# REANA_SECRETS_SECRET='reana-secrets.yaml'
# RAW_REANA_SECRETS_FILE_SECRET=${RAW_SECRETS_TMP_DIR}/${REANA_SECRETS_SECRET}

# cat ${RAW_REANA_SECRETS_FILE_SECRET} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${REANA_NS} > ${SECRETS_DIR}/ss_${REANA_SECRETS_SECRET}
# kubectl apply -f ${SECRETS_DIR}/ss_${REANA_SECRETS_SECRET}


echo "END REANA Secret Script"