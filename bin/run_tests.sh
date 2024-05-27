#!/bin/sh

BASE=$(pwd)


# ------------------------------------------------------------------------------
#
usage(){
    msg=$1

    echo <<EOT
Usage: $0 [directory]

This script will run the RCT stack installed in <directory>/ve.

If no directory is specified, ./rct.tests will be used.

EOT

    if ! test -z "$msg"
    then
        echo "Error: $msg"
        exit 1
    fi

    exit 0
}


# ------------------------------------------------------------------------------
#
activate_ve(){

    dir="$1"

    if ! test -d "$dir/ve"
    then
        usage "No virtualenv found in $dir/ve"
    fi

    . "$dir/ve/bin/activate"
}


# ------------------------------------------------------------------------------
#
run_test(){

    dir="$1"

    cd "$dir"

    export RADICAL_LOG_LEVEL=DEBUG
    export RADICAL_REPORT=FALSE

    $BASE/bin/rp_test.py
    sid=$(ls -rtad rp.session.* | tail -n 1)

    echo "SID: $sid"
    radical-analytics-inspect "$sid"
}


# ------------------------------------------------------------------------------
#
main(){

    dir="$1"

    mkdir -p "$dir"

    if ! test -d "$dir"
    then
        usage "Could not create directory $dir"
    fi

    cd "$dir"

    activate_ve "$dir"

    run_test "$dir"
}


# ------------------------------------------------------------------------------
#
dir=$1

test    "$dir" = "--help" && usage
test    "$dir" = "-h"     && usage
test -z "$dir"            && dir='./rct.tests'

dir=$(readlink -f "$dir")

main "$dir"


# ------------------------------------------------------------------------------

