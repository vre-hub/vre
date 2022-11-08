#!/bin/bash

# Rucio Secret Creation Process
# 1. Create a LanDB Alias for all the required CNAMES like so: openstack server set --property landb-alias=eoscf-rucio,eoscf-rucio-auth,eoscf-rucio-ui <cluster-name>-node-0
# 2. Create and download host certificates form the CERN CA Authority here: https://ca.cern.ch/ca/
# 3. Split them into a cert/key file each by following this documentation: https://ca.cern.ch/ca/Help/?kbid=024010
# 4. Use the below script (modify variabels if needed) to create a SealedSecret for each one of them and deploy them to the cluster

echo "--> create rucio secrets"

controller_ns="shared-services"

helm_release_name_ui="rucio-ui-eoscf1"
helm_release_name_server="rucio-server-eoscf1"
helm_release_name_daemons="rucio-daemons-eoscf1"

rucio_namespace="rucio-test"

yml_output_prefix="ss_"

echo "--> create and apply server secrets"

kubectl create secret generic ${helm_release_name_server}-hostcert --dry-run=client --from-file=eoscf-rucio_cert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio_cert.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio_cert.yaml

kubectl create secret generic ${helm_release_name_server}-hostkey --dry-run=client --from-file=eoscf-rucio_key.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio_key.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio_key.yaml

kubectl create secret generic ${helm_release_name_server}-server-cafile --dry-run=client --from-file=/etc/pki/tls/certs/CERN-bundle.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}server-cafile.yaml

kubectl apply -f ${yml_output_prefix}server-cafile.yaml

echo "--> create and apply auth secrets"

kubectl create secret generic ${helm_release_name_server}-hostcert --dry-run=client --from-file=eoscf-rucio-auth_cert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio-auth_cert.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio-auth_cert.yaml

kubectl create secret generic ${helm_release_name_server}-hostkey --dry-run=client --from-file=eoscf-rucio-auth_key.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio-auth_key.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio-auth_key.yaml

kubectl create secret generic ${helm_release_name_server}-auth-cafile --dry-run=client --from-file=/etc/pki/tls/certs/CERN-bundle.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}auth-cafile.yaml

kubectl apply -f ${yml_output_prefix}auth-cafile.yaml

echo "--> create and apply ui secrets"

kubectl create secret generic ${helm_release_name_ui}-hostcert --dry-run=client --from-file=eoscf-rucio-ui_cert.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio-ui_cert.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio-ui_cert.yaml

kubectl create secret generic ${helm_release_name_ui}-hostkey --dry-run=client --from-file=eoscf-rucio-ui_key.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}eoscf-rucio-ui_key.yaml

kubectl apply -f ${yml_output_prefix}eoscf-rucio-ui_key.yaml

kubectl create secret generic ${helm_release_name_server}-cafile --dry-run=client --from-file=/etc/pki/tls/certs/CERN-bundle.pem -o yaml | \
kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}cafile.yaml

kubectl apply -f ${yml_output_prefix}cafile.yaml

echo "--> create rucio bundel"

bundle_dir="/root/test-certs/bundle"
cp /etc/grid-security/certificates/*.0 ${bundle_dir}
cp /etc/grid-security/certificates/*.signing_policy ${bundle_dir}

# kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle-reaper --dry-run=client --from-file=${bundle_dir} -o yaml | \
# kubeseal --controller-name=sealed-secrets --controller-namespace=${controller_ns} --format yaml --namespace=${rucio_namespace} > ${yml_output_prefix}rucio-bundle.yaml

# kubectl apply -f ${yml_output_prefix}rucio-bundle.yaml

kubectl create secret generic ${helm_release_name_daemons}-rucio-ca-bundle-reaper --from-file=${bundle_dir} -n rucio-test