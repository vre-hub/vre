#! /bin/bash

# Set variables
RUCIO_FTS_VOMS="ms:/cms/Role=production"
RUCIO_FTS_SERVERS="https://fts3-pilot.cern.ch:8446"
RUCIO_FTS_SECRETS="rucio-daemons-cvre-rucio-x509up"

# We have to copy the certificates because we cannot change permissions on them as mounted secrets and voms-proxy is particular about permissions
chmod 600 usercert.pem
chmod 600 new_userkey.pem

# Generate a proxy with the voms extension if requested
voms-proxy-init --debug -rfc -valid 96:00 -bits 2048 -cert usercert.pem -key new_userkey.pem -out x509up -voms escape -rfc -timeout 5

# Delegate the proxy to the requested servers
fts-rest-delegate -v -f -H 96 --key=x509up --cert=x509up -s https://fts3-pilot.cern.ch:8446

# kubectl get secret rucio-server-cvre-rucio-db -n rucio -o yaml > rucio-daemons-cvre-rucio-db.yaml

# Create the corresponding kubernetes secrets if asked
kubectl create secret generic rucio-daemons-cvre-rucio-x509up -n rucio --from-file=x509up --dry-run=client -o yaml | kubectl apply --validate=false  -f  -