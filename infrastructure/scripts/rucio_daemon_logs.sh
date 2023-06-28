#!/bin/sh 

# this command makes sure that the script stops if something goes bad as everything runs in the background

RUCIO_NS='rucio-vre'
what='test'

for OUTPUT in $(kubectl -n ${RUCIO_NS} get pods | cut -d " " -f1 | grep daemons | grep -vw 'automatic' | grep -vw 'renew-fts-proxy')
do
    echo -e "\033[1mChecking for " $OUTPUT
    kubectl logs -n ${RUCIO_NS} $OUTPUT | grep $what
done
