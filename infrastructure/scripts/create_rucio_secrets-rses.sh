#!/bin/bash

# S3 storage configuration needs to be applied to the RUCIO serves, following RUCIO documentation
#  http://rucio.cern.ch/documentation/s3_rse_config/

HELM_RELEASE_SERVER="rucio-server-cvre"
# Secrets should only be applied to server, not daemons
#HELM_RELEASE_DAEMONS="rucio-daemons-cvre"

CONTROLLER_NS="shared-services"
CONTROLLER_NAME="sealed-secrets-cvre"

# rucio namespace
RUCIO_NS="rucio"

# sealed secret output yaml prefix
YAML_PRFX="ss_"

SECRETS_STORE="../secrets/rucio/"

kubectl create secret generic ${HELM_RELEASE_SERVER}-rse-accounts --dry-run=client --from-file=../secrets/tmp_local_secrets/rse-accounts.json -o yaml \
| kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rse-accounts.yaml
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rse-accounts.yaml

# kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rse-accounts --dry-run=client --from-file=../secrets/tmp_local_secrets/rse-accounts.json -o yaml \
# | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-rse-accounts.yaml
# kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-rse-accounts.yaml
