#!/bin/bash

# Create required certificate secrets for RUCIO
#
# Please note that this script is CERN specific and might need to be adjusted to the needs of your organisation
# 
# Steps to 
# 1. Create a LanDB alias for all the required CNAMES like so: openstack server set --property landb-alias=<alias-one>,<alias-two> <cluster-name>-node-0 or, when using a loadbalancer, use the description field.
# 2. Create and download host certificates form the CERN CA Authority here: https://ca.cern.ch/ca/
# 3. Split them into a cert/key file each by following this documentation: https://ca.cern.ch/ca/Help/?kbid=024010
# 4. Use the below script in the scripts directory (modify variabels if needed) to create a SealedSecret for each one of them and deploy them to the cluster
# 5. The kubeseal controller will immediately create the kubernetes secret and maintain it, the sealed secret file is safe to commit to the repo

echo "Create RUCIO Secrets Script Start"

# kubeseal controller namespace
CONTROLLER_NS="shared-services"
CONTROLLER_NAME="sealed-secrets-cvre"

# helm release names
HELM_RELEASE_SERVER="rucio-server-cvre"
helm_release_name_ui="rucio-ui-cvre"
HELM_RELEASE_DAEMONS="rucio-daemons-cvre"

# rucio namespace
RUCIO_NS="rucio"

# sealed secret output yaml prefix
YAML_PRFX="ss_"

# file location of raw certificate files (dir excluded from commit)
RAW_SECRETS="secrets/tmp_local_secrets/"
RAW_SECRETS_MAIN="secrets/tmp_local_secrets/main/"
RAW_SECRETS_AUTH="secrets/tmp_local_secrets/auth/"
RAW_SECRETS_UI="secrets/tmp_local_secrets/ui/"
RAW_SECRETS_NB="secrets/tmp_local_secrets/notebook/"
RAW_SECRETS_BUNDLE="secrets/tmp_local_secrets/bundle/"
RAW_SECRETS_FTS="secrets/tmp_local_secrets/bundle/fts/"

# Output dir
SECRETS_STORE="secrets/"

echo "Create and apply main server secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostcert --dry-run=client --from-file=${RAW_SECRETS_MAIN}hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-server-hostkey --dry-run=client --from-file=${RAW_SECRETS_MAIN}hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-hostkey.yaml

cp /etc/pki/tls/certs/CERN-bundle.pem /etc/pki/tls/certs/ca.pem # this is due to a problem with the filename?
kubectl create secret generic ${HELM_RELEASE_SERVER}-server-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-server-cafile.yaml

echo "Create and apply auth server secrets"

kubectl create secret generic ${HELM_RELEASE_SERVER}-auth-hostcert --dry-run=client --from-file=${AUTHPROXIES}hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-auth-hostkey --dry-run=client --from-file=${AUTHPROXIES}hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-hostkey.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-auth-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-auth-cafile.yaml

echo "Create and apply ui secrets"

kubectl create secret generic ${helm_release_name_ui}-hostcert --dry-run=client --from-file=${RAW_SECRETS_UI}hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-hostcert.yaml

kubectl create secret generic ${helm_release_name_ui}-hostkey --dry-run=client --from-file=${RAW_SECRETS_UI}hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-hostkey.yaml

kubectl apply -f  ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_SERVER}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${helm_release_name_ui}-cafile.yaml

echo "Create rucio CA bundle for daemons"

rm -rf ${RAW_SECRETS_BUNDLE}
mkdir ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.0 ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.signing_policy ${RAW_SECRETS_BUNDLE}

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle-reaper --from-file=${RAW_SECRETS_BUNDLE} -n rucio # kubeseal has problems with secretsthis large, so it needs to be created manually
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle --from-file=${RAW_SECRETS_BUNDLE} -n rucio

echo "Create TLS secret"

# kubectl create secret tls vre-rucio-server.tls-secret --key=${RAW_SECRETS_MAIN}hostkey.pem --cert=${RAW_SECRETS_MAIN}hostcert.pem -n=rucio 

echo "Create rucio DB secret"

kubectl -n rucio create secret generic ${HELM_RELEASE_SERVER}-rucio-db --from-literal=dbconnectstring=${DB_CONNECT_STRING} --dry-run=client -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rucio-db.yaml # DB_CONNECT_STRING should be set manually in console beforehand

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rucio-db.yaml

echo "Create service account secret for rucio client container to check initial server connection"

cat ${RAW_SECRETS}sso-secret.yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}-sso-account.yaml
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}-sso-account.yaml

echo "Create and apply fts secrets"

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-cert --dry-run=client --from-file=${RAW_SECRETS_FTS}usercert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl apply -f ${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-key --dry-run=client --from-file=${RAW_SECRETS_FTS}new_userkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-key.yaml

kubectl apply -f ${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-key.yaml
