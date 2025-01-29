#!/bin/bash

# not needed if not CRIC
# python3 /home/user/eosc-crons/cric-info-tools/list_rses_from_cric.py -o /home/user/eosc-crons/cric-info-tools/list_rses_from_cric.txt -i /home/user/eosc-crons/cric-info-tools/disabled_rses.txt

rses=()
while read line
do
    rses+=($line) 

done < /home/rses.txt
len=${#rses[@]}

echo $rses
echo '* Assigning ENV Config Variables:'
FILE_SIZE=${FILE_SIZE:-100M}
RUCIO_SCOPE=${RUCIO_SCOPE:-test}
FILE_LIFETIME=${FILE_LIFETIME:-3600}
echo '*   FILE_SIZE = '"$FILE_SIZE"''
echo '*   RUCIO_SCOPE = '"$RUCIO_SCOPE"''
echo '*   FILE_LIFETIME = '"$FILE_LIFETIME"''

upload_and_transfer_and_delete () {

    for (( i=1; i<=$len; i++ )); do

        echo '*** ======================================================================== ***'
        echo '*** '"${rses[$i]}"' ***'

        RANDOM_STRING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
        echo '*** generated random file identifier: '"$RANDOM_STRING"' ***'
        filename=/home/auto_uploaded_${RANDOM_STRING}_source${rses[$1]}
        did=auto_uploaded_${RANDOM_STRING}_source${rses[$i]}
        
        echo '*** generating '"$FILE_SIZE"' file on local storage ***'
        head -c $FILE_SIZE < /dev/urandom  > $filename
        echo '*** filename: '"$filename"' ***'

        echo '*** uploading filename: '"$filename"' to '"${rses[$i]}"' ***'
        rucio -v upload --rse ${rses[$1]} --lifetime $FILE_LIFETIME --scope $RUCIO_SCOPE $filename

        for (( j=1; j<=$len; j++ )); do

            if [ $i != $j ]; then

            echo '*** adding rule from '"${rses[$i]}"' to '"${rses[$j]}"' ***'
            rucio -v add-rule --lifetime $FILE_LIFETIME --activity "Functional Test" $RUCIO_SCOPE:$did 1 ${rses[$j]}

            fi
            
        done

        echo '*** Uploaded files and replicas should disappear after '${FILE_LIFETIME}' seconds ***'
        # echo '*** Otherwise do a `rucio -v erase $RUCIO_SCOPE:$did` ***'

    done
}

echo '* RUCIO Produce Noise script START * '

for (( j=0; j<$len; j++ )); do
    upload_and_transfer_and_delete $j
done

echo '* RUCIO Produce Noise script DONE * '
