# RUN this from the folder where the file $yaml_file_secret is located: for reana, we need to change the 
# 1. database connection, if using an external db
# 2. the IAM client used to identify with IAM 

# kubeseal controller namespace
CONTROLLER_NS="shared-services"
CONTROLLER_NAME="sealed-secrets-cvre"

# rucio namespace
RUCIO_NS="reana"

# sealed secret output yaml prefix
YAML_PRFX="ss_"

# ONLY VARIABLE YOU NEED TO CHANGE
yaml_file_secret="reana-vre-db.yaml"

# Output dir, use your own
SECRETS_STORE="/root/clusters/vre-cluster/vre-hub/vre/infrastructure/secrets/reana/"

# name of output secret to apply
OUTPUT_SECRET=${YAML_PRFX}${yaml_file_secret}

echo "Create secret from file "

cat ${yaml_file_secret} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_STORE}${OUTPUT_SECRET}

kubectl apply -f ${SECRETS_STORE}${OUTPUT_SECRET}