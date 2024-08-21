echo " *** START rucio DAEMONS Script"

# Once the certificates have been split, provide their path to be read when creating the secrets (NEEDS TO BE EXCLUDED FROM COMMITS!!):
RAW_SECRETS_DAEMONS="/root/clusters_CERTS/vre/daemons"
RAW_SECRETS_BUNDLE="/root/clusters_CERTS/vre/daemons/ca-bundle_files/"
RAW_SECRETS_FTS="/root/clusters_CERTS/vre/daemons/fts-robot-cert/"
RAW_SECRETS_IDP="/root/software/vre/infrastructure/secrets/tmp_local_secrets/idpsecrets.json"


# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller"

# rucio namespace
RUCIO_NS="rucio"
HELM_RELEASE_DAEMONS="daemons"

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"

# The content of this file is the same as in /etc/pki/tls/certs/CERN-bundle.pem but renamed to ca.pem
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-cafile --dry-run=client --from-file=${RAW_SECRETS_DAEMONS}/cafile.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-cafile.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-cafile.yaml

echo " *** Create and apply IDP secrets for DAEMONS"

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-idpsecrets --dry-run=client --from-file=${RAW_SECRETS_IDP} -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-idpsecrets.yaml

echo " *** Create and apply rucio-ca-bumndle secrets for CONVEYOR and REAPER"

mkdir -p ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.0 ${RAW_SECRETS_BUNDLE}
cp /etc/grid-security/certificates/*.signing_policy ${RAW_SECRETS_BUNDLE}

# kubeseal has problems with secretsthis large, so it needs to be created manually and not applied with kubeseal
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS}
kubectl create secret generic ${HELM_RELEASE_DAEMONS}-rucio-ca-bundle-reaper --from-file=${RAW_SECRETS_BUNDLE} --namespace=${RUCIO_NS} 

echo " *** Create and apply fts-cert and fts-key secrets for FTS RENEWER"

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-cert --dry-run=client --from-file=${RAW_SECRETS_FTS}/usercert.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-fts-cert.yaml

kubectl create secret generic ${HELM_RELEASE_DAEMONS}-fts-key --dry-run=client --from-file=${RAW_SECRETS_FTS}/userkey.pem -o yaml | \
kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-fts-key.yaml

kubectl apply -f ${SECRETS_DIR}/ss_${HELM_RELEASE_DAEMONS}-fts-key.yaml

echo " *** END rucio DAEMONS Script"