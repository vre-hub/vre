echo " *** START rucio UI Secrets script"

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_UI="/root/clusters_CERTS/vre/ui"
RAW_SECRETS_IDP="/root/software/vre/infrastructure/secrets/tmp_local_secrets/idpsecrets.json"


# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller"

# rucio namespace
RUCIO_NS="rucio"
HELM_RELEASE_UI="ui"

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"

echo " *** Create and apply UI secrets"

# Check the names of the secrets on the chart documentation
# https://github.com/rucio/helm-charts/tree/rucio-ui-34.0.5/charts/rucio-ui#service

kubectl create secret generic ${HELM_RELEASE_UI}-hostcert --dry-run=client --from-file=${RAW_SECRETS_UI}/hostcert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-hostcert.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-hostcert.yaml

kubectl create secret generic ${HELM_RELEASE_UI}-hostkey --dry-run=client --from-file=${RAW_SECRETS_UI}/hostkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-hostkey.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-hostkey.yaml

# The content of this file is the same as in /etc/pki/tls/certs/CERN-bundle.pem but renamed to cafile.pem
kubectl create secret generic ${HELM_RELEASE_UI}-cafile --dry-run=client --from-file=${RAW_SECRETS_UI}/cafile.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-cafile.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_UI}-cafile.yaml


echo " *** END rucio UI Secrets Script"