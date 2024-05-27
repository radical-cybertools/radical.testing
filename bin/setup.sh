#!/bin/sh

base=$(pwd)

repos="radical.gtod radical.utils radical.pilot radical.entk radical.analytics"



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
prepare_ve(){

    dir="$1"

    if ! test -d "$dir/ve"
    then
        python3 -m venv "$dir/ve"
    fi

    . "$dir/ve/bin/activate"
}


# ------------------------------------------------------------------------------
#
checkout(){
    dir="$1"
    repo="$2"

    cd "$dir"

    if ! test -d "$repo"
    then
        git clone "https://github.com/radical-cybertools/$repo.git"
    fi

    cd "$repo"
    git pull
}


# ------------------------------------------------------------------------------
#
install(){

    dir="$1"
    repo="$2"

    cd "$dir/$repo"
    pip install --upgrade .
}


# ------------------------------------------------------------------------------
#
check(){

    radical-stack

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

    prepare_ve "$dir"


    for repo in $repos
    do
        checkout "$dir" "$repo"
        install  "$dir" "$repo"
    done

    check "$dir"

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

