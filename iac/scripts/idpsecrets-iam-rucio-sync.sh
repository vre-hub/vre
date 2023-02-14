#!/bin/bash

# Only one idpsecrets.json file is needed to create these three essential secrets that manage the authentication and token exchange for users. 
# They manage the sync between the VRE Rucio instance and the IAM ESCAPE instance. 
# Two clients need to be registered on the IAM ESCAPE instance; 

# 1. auth client
# 2. admin client 

# Both the admin and auth client are included in the idpsecrets.json file. 

HELM_RELEASE_SERVER="rucio-server-cvre"
HELM_RELEASE_UI="rucio-ui-cvre"
HELM_RELEASE_DAEMONS="rucio-daemons-cvre"

CONTROLLER_NS="shared-services"
CONTROLLER_NAME="sealed-secrets-cvre"

# rucio namespace
RUCIO_NS="rucio"

# sealed secret output yaml prefix
YAML_PRFX="ss_"

SECRETS_STORE="../secrets/rucio/"

kubectl create secret generic ${HELM_RELEASE_SERVER}-idpsecrets --dry-run=client --from-file=idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-idpsecrets --dry-run=client --from-file=idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-idpsecrets --dry-run=client --from-file=idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-idpsecrets.yaml
