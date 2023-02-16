#!/bin/bash

# Script to create a new RSE fromt he rucio-admin comman dline

export RSE-NAME=CNAF-STORM 
export HOSTNAME=xfer.cr.cnaf.infn.it

# THIS IS IMPORTANT: possible protocols are https/davs, gsiftp, root, s3s
export SCHEME=davs # protocol for communicating to endpoint 
export PATH_PREFIX=/escape/rucio/cnaf_storm # path to endpoint storage
export PORT=8443

# DISTANCES BETWEEN RSES MUST BE SPECIFIED BOTH WAYS OTHERWISE TRANSFER WILL NOT HAPPEN!
export RSE2-DISTANCE=EULAKE-1
export MINFREESPACE=100000000000 

rucio-admin rse add ${RSE-NAME}

rucio-admin rse set-attribute --rse ${RSE-NAME} --key QOS --value OPPORTUNISTIC
rucio-admin rse set-attribute --rse ${RSE-NAME} --key fts --value https://fts3-pilot.cern.ch:8446
rucio-admin rse set-attribute --rse ${RSE-NAME} --key greedyDeletion  --value True
rucio-admin rse set-attribute --rse ${RSE-NAME} --key lfn2pfn_algorithm --value hash
rucio-admin rse set-attribute --rse ${RSE-NAME} --key oidc_support --value True
rucio-admin rse set-attribute --rse ${RSE-NAME} --key verify_checksum --value True
rucio-admin rse set-attribute --rse ${RSE-NAME} --key SITE --value CERN #or wherever the RSE is 

rucio-admin rse add-protocol --hostname ${HOSTNAME} --scheme ${SCHEME} --prefix ${PATH_PREFIX} --port ${PORT} --impl rucio.rse.protocols.gfal.Default --domain-json '{"lan": {"read": 1, "write": 1, "delete": 1}, "wan": {"read": 1, "write": 1, "delete": 1, "third_party_copy_read": 1, "third_party_copy_write": 1}}' ${RSE-NAME}

# in need for a loop maybe
rucio-admin rse add-distance ${RSE-NAME} ${RSE2-DISTANCE} --distance 15
rucio-admin rse add-distance ${RSE2-DISTANCE} ${RSE-NAME} --distance 15

rucio-admin rse set-limit ${RSE-NAME} ${MINFREESPACE} 

rucio-admin account set-limits root CNAF-STORM ${MINFREESPACE} # DO FOR ALL ACCOUNTS? NECESSARY?
 
rucio-admin rse info ${RSE-NAME}

# to debug which rules on which RSE

rucio list-rules --account root