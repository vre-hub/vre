#!/bin/bash

echo " *** START rucio POLICY PACKAGE Secret and Deployment Script ***"

SECRET_RAW_DIR="/root/software/vre/infrastructure/secrets/tmp_local_secrets"
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"

echo "  *** Uploading ESCAPE Rucio Policy package ***"

# Yes, this file is created by hand as follows.
# An automatic way of dumping new releases of the policy package would save
# a lot of problems and headaches.
#
# rucio_escape_policy_package.yaml
# apiVersion: v1
# kind: Secret
# metadata:
#   namespace: rucio
#   name: escape-rucio-policy-package
# type: Opaque
# stringData:
#   __init__.py: |-
#     SUPPORTED_VERSION = [ "1.28", "1.29", "1.30", "1.31", "32" "33", "34", "35"]
#   permission.py: |-
#     (...)
#   schema.py: |-
#     (...)
#
FILENAME_SECRET="escape-rucio-policy-package.yaml"
SECRET_FILE="${SECRET_RAW_DIR}/${FILENAME_SECRET}"
cat $SECRET_FILE | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${FILENAME_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${FILENAME_SECRET}

echo " *** DONE *** "