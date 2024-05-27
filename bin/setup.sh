#!/bin/sh

# ------------------------------------------------------------------------------
#
usage(){
    msg=$1

    echo <<EOT
Usage: $0 [directory]

This script will clone the RCT repositories into the specified directory (which will be created if needed), and will set up the test suite in that location.

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
checkout(){
    repo=$1

    if test -d "$repo"
    then
        echo "Updating $repo"
        cd "$repo"
        git pull
        cd ..
    else
        echo "Cloning $repo"
        git clone "$repo"
    fi
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

    checkout radical.gtod
    checkout radical.utils
    checkout radical.pilot
    checkout radical.entk
    checkout radical.analytics
}


# ------------------------------------------------------------------------------
#
dir=$1

test    "$dir" = "--help" && usage
test    "$dir" = "-h"     && usage
test -z "$dir"            && dir='./rct.tests'

main "$dir"


# ------------------------------------------------------------------------------

