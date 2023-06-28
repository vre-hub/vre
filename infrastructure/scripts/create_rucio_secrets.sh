#!/bin/bash

# Create required certificate secrets for RUCIO
#
# Please note that this script is CERN specific and might need to be adjusted to the needs of your organisation
# 
# Steps to 
# 1. Create a LanDB alias for all the required CNAMES like so: openstack server set --property landb-alias=<alias-one>,<alias-two> <cluster-name>-node-0 or, when using a loadbalancer, use the description field.
# 2. Create and download host certificates form the CERN CA Authority here: https://ca.cern.ch/ca/
# 3. Split them into a cert/key file each by following this documentation: https://ca.cern.ch/ca/Help/?kbid=024010 or using this scripts first part
# 4. Use the below script in the scripts directory (modify variabels if needed) to create a SealedSecret for each one of them and deploy them to the cluster
# 5. The kubeseal controller will immediately create the kubernetes secret and maintain it, the sealed secret file is safe to commit to the repo

echo "Create RUCIO Secrets Script START"

# Convert Certificte to PEM Keypair and adjust permission
# CERT_FLENAME="myCert"
# HOSTCERT="hostcert"
# HOSTKEY="hostkey"

# openssl pkcs12 -in ${CERT_FLENAME}.p12 -clcerts -nokeys -out ${HOSTCERT}.pem
# openssl pkcs12 -in ${CERT_FLENAME}.p12 -nocerts -out ${HOSTKEY}.pem

# chmod 600 ${HOSTCERT}.pem
# chmod 600 ${HOSTKEY}.pem

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_DB="/root/clusters/vre-cluster/rucio-secrets/rucio-database/"
RAW_SECRETS_MAIN="/root/clusters/vre-cluster/rucio-secrets/main/"
AUTHPROXIES="/root/clusters/vre-cluster/rucio-secrets/auth/"
RAW_SECRETS_UI="/root/clusters/vre-cluster/rucio-secrets/webui/"
RAW_SECRETS_BUNDLE="/root/clusters/vre-cluster/rucio-secrets/ca-bundle/"
RAW_SECRETS_FTS="/root/clusters/vre-cluster/rucio-secrets/fts/"
RAW_SECRETS_IDP="/root/clusters/vre-cluster/rucio-secrets/"
# RAW_SECRETS="secrets/tmp_local_secrets/"
# RAW_SECRETS_MAIN="secrets/tmp_local_secrets/main/"
# RAW_SECRETS_AUTH="secrets/tmp_local_secrets/auth/"
# RAW_SECRETS_UI="secrets/tmp_local_secrets/ui/"
# RAW_SECRETS_NB="secrets/tmp_local_secrets/notebook/"
# RAW_SECRETS_BUNDLE="secrets/tmp_local_secrets/bundle/"
# RAW_SECRETS_FTS="secrets/tmp_local_secrets/bundle/fts/"

# kubeseal controller namespace
CONTROLLER_NS="shared-services"
CONTROLLER_NAME="sealed-secrets-cvre"

# helm release names
HELM_RELEASE_SERVER="servers-vre"
HELM_RELEASE_UI="webui-vre"
HELM_RELEASE_DAEMONS="daemons-vre"

# rucio namespace
RUCIO_NS="rucio-vre"

# sealed secret output yaml prefix
YAML_PRFX="ss_"

# Output dir
SECRETS_STORE="/root/clusters/vre-cluster/vre-hub/vre/infrastructure/secrets/rucio-vre/"

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

kubectl create secret generic ${HELM_RELEASE_UI}-hostcert --dry-run=client --from-file=${RAW_SECRETS_UI}hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-hostcert.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-hostkey --dry-run=client --from-file=${RAW_SECRETS_UI}hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-hostkey.yaml

kubectl apply -f  ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-hostkey.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-cafile.yaml


echo "Create rucio CA bundle for daemons"

rm -rf ${RAW_SECRETS_BUNDLE}
mkdir ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.0 ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.signing_policy ${RAW_SECRETS_BUNDLE}

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle-reaper --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS} # kubeseal has problems with secretsthis large, so it needs to be created manually
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS}

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/ca.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-cafile.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-cafile.yaml

echo "Create TLS secret"

kubectl create secret tls rucio-server.tls-secret --dry-run=client --key=${RAW_SECRETS_MAIN}hostkey.pem --cert=${RAW_SECRETS_MAIN}hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}rucio-server.tls-secret

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}rucio-server.tls-secret

echo "Create RSE secret for server to recognise S3 storage"

kubectl create secret generic ${HELM_RELEASE_SERVER}-rse-accounts --dry-run=client --from-file=/root/clusters/vre-cluster/rucio-secrets/rse-accounts.json -o yaml \
| kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rse-accounts.yaml
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-rse-accounts.yaml

echo "Create rucio DB secret"

yaml_file_secret="/root/clusters/vre-cluster/rucio-secrets/rucio-database/rucio-db.yaml"

# name of output secret to apply
OUTPUT_SECRET="rucio-db.yaml"
cat ${yaml_file_secret} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}

echo "Create hermes secret"

yaml_file_secret="/root/clusters/vre-cluster/rucio-secrets/hermes-secret.yaml"

# name of output secret to apply
OUTPUT_SECRET="hermes-secret.yaml"
cat ${yaml_file_secret} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}

# rm -rf ${OUTPUT_SECRET}

echo "Create idp (IAM client for rucio accounts sync) secret"
# WATCH OUT that the secret needs to be called ${HELM_RELEASE_SERVER}-idpsecrets, but the reference in the .yaml file is only:

# additionalSecrets:
 #     idpsecrets:
 #       secretName: idpsecrets
 #       mountPath: /opt/rucio/etc/idpsecrets.json
 #       subPath: idpsecrets.json

kubectl create secret generic ${HELM_RELEASE_SERVER}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP}idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_SERVER}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP}idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_UI}-idpsecrets.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP}idpsecrets.json -o yaml | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

echo "Create escape-service-account secret"

yaml_file_secret="/root/clusters/vre-cluster/rucio-secrets/escape-service-account.yaml"

# name of output secret to apply
OUTPUT_SECRET="escape-service-account.yaml"
cat ${yaml_file_secret} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${OUTPUT_SECRET}

echo "Create and apply FTS secrets from ESCAPE robot certificate"

## NB: the key needs to be called 'new_userkey.pem'

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-cert --dry-run=client --from-file=${RAW_SECRETS_FTS}usercert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-key --dry-run=client --from-file=${RAW_SECRETS_FTS}new_userkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-key.yaml

kubectl apply -f ${SECRETS_STORE}${YAML_PRFX}${HELM_RELEASE_DAEMONS}-fts-key.yaml


echo "Create RUCIO Secrets Script END"