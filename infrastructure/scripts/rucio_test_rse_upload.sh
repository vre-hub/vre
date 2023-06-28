#!/bin/sh

now=`date +"%Y-%m-%d"`
run_n='01'

for rse in $(rucio list-rses)
do
    echo -e "\033[1mAttempting upload of" test-$run_n-$now-$rse.txt
    mv test* test-$run_n-$now-$rse.txt
    rucio -vvv upload --scope test --rse $rse test-$run_n-$now-$rse.txt
done

