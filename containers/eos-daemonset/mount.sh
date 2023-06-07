#!/bin/bash

EOSXD_MOUNT_HEALTH_CHECK_INTERVAL=5

function mount {
    echo "eos: adding fuse mount /eos"
    mkdir -p /eos || true
    
    /usr/bin/eosxd -o allow_other,rw,fsname=eulake &
}

function check_mount {
    EOSXD=$(pgrep -u root -f "eosxd" || true)
    if [[ -z "${EOSXD}" ]]
    then
        echo "/eos should be mounted but corresponding eosxd is not running. Re-mounting."
        umount /eos || true
        mount
    fi
}

function exit_script() {
    SIGNAL=$1
    echo "Caught $SIGNAL! Unmounting /eos..."
    umount /eos || true
    trap - $SIGNAL # clear the trap
    exit $?
}

trap "exit_script INT" INT
trap "exit_script TERM" TERM

mount

while true; do
    sleep "${EOSXD_MOUNT_HEALTH_CHECK_INTERVAL}"
    check_mount
done
