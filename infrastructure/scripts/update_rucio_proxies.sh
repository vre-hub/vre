#!/bin/sh 

## PURPOSE
## script to update the proxy certificates for the rucio daemons. 
## The /x509 file gets created every 8 hours (the suration is 12 hours) from the command voms-proxy-init on the x509 certificate 
## and it is used y the rucio daemons to perform the transfers with the File Transfer Service (FTS). 

# this command makes sure that the script stops if something goes bad as everything runs in the background
set -e 
 
PROXYPATH="/afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/proxies/"
RELEASENAMEDAEMONS="daemons-vre"
RUCIO_NS="rucio-vre"
export KUBECONFIG=/afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/config-vre

cd ${PROXYPATH}
# generating the robot client proxies
voms-proxy-init --cert ./client.crt --key ./client.key --out x509up_escape --voms escape

export ROBOT_CLIENT_CERT="/afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/proxies/client.crt"
export ROBOT_CLIENT_KEY="/afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/proxies/client.key"

export X509_USER_PROXY="/afs/cern.ch/user/e/egazzarr/private/clusters/vre-cluster/proxies/x509up_escape"

# copying the robot client certificate in each daemon pod (had to exclude the automatic restart)
cp ${X509_USER_PROXY} x509up 
for OUTPUT in $(kubectl -n ${RUCIO_NS} get pods | cu-d " " -f1 | grep daemons | grep -vw 'automatic' | grep -vw 'renew-fts-proxy')
do
    echo $OUTPUT
    kubectl -n ${RUCIO_NS} cp x509up $OUTPUT:/x509up
done

# rucio daemons x509_up secret
kubectl delete secret ${RELEASENAMEDAEMONS}-rucio-x509up -n ${RUCIO_NS}
kubectl create secret generic ${RELEASENAMEDAEMONS}-rucio-x509up --from-file=x509up -n ${RUCIO_NS}

# x509up for Crons
#kubectl delete secret prod-rucio-x509up -n crons
#kubectl create secret generic prod-rucio-x509up --from-file=x509up -n crons
#kubectl delete secret prod-rucio-x509up
#kubectl create secret generic prod-rucio-x509up --from-file=x509up

kubectl delete secret prod-rucio-x509up -n ${RUCIO_NS}
kubectl create secret generic prod-rucio-x509up --from-file=x509up -n ${RUCIO_NS}

# FTS delegation (needed?) renewed
ssh lxplus fts-rest-delegate -s https://fts3-pilot.cern.ch:8446 --verbose --key ${ROBOT_CLIENT_KEY} --cert ${ROBOT_CLIENT_CERT}

#FTS delegation old only on lxplus
#ssh lxplus fts-delegation-init -s https://fts3-pilot.cern.ch:8446 --proxy ${X509_USER_PROXY}

exit 0
 
