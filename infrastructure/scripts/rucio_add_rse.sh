#!/bin/sh

# complete with your own paramters!!

##############################################################################################################
new_rse='<new_rse>'
hostname='<hostname>'
scheme='<scheme>'
prefix='<prefix>'
port='<port>'
site='<site>'
lat='<latitude>'
long='<longitude>'
minfreespace='<limit in B unit>'
##############################################################################################################

# adding the new RSE

rucio-admin rse add $new_rse

rucio-admin rse add-protocol --hostname $hostname \
--scheme $scheme \
--prefix $prefix\
--port $port \
--impl rucio.rse.protocols.gfal.Default \
--domain-json '{"lan": {"read": 3, "write": 3, "delete": 3}, "wan": {"read": 3, "write": 3, "delete": 3, "third_party_copy_read": 3, "third_party_copy_write": 3}}' $new_rse

# adding all RSE attributes 

rucio-admin rse set-attribute --rse $new_rse --key QOS --value OPPORTUNISTIC
rucio-admin rse set-attribute --rse $new_rse --key SITE --value $site
rucio-admin rse set-attribute --rse $new_rse --key fts --value https://fts3-pilot.cern.ch:8446
rucio-admin rse set-attribute --rse $new_rse --key lfn2pfn_algorithm --value hash
rucio-admin rse set-attribute --rse $new_rse --key oidc_support --value True 
rucio-admin rse set-attribute --rse $new_rse --key verify_checksum --value True 
rucio-admin rse set-attribute --rse $new_rse --key latitude --value $lat
rucio-admin rse set-attribute --rse $new_rse --key longitude --value $long

# adding rse limit 
rucio-admin rse set-limit $new_rse MinFreeSpace $minfreespace 

# adding distances between sources and destinations for transfers to happen 

for rse in $(rucio list-rses)
do
    echo -e "\033[1mAdding distance between" $rse "and" $new_rse 
    rucio-admin rse add-distance --distance 15 $rse $new_rse
    echo -e "\033[1mAdding distance between" $new_rse "and" $rse
    rucio-admin rse add-distance --distance 15 $new_rse $rse  
done

