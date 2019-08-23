#!/bin/bash
REBUILD=0

while getopts 'r' opt; do
    case $opt in
        r) REBUILD=1 ;;
        *) echo 'Error in command line parsing' >&2
           exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch to build the image with among:'
    echo '- master'
    echo '- dev_controllers'
    exit 0
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

if [ "$REBUILD" -eq 1 ]; then
	docker build --no-cache --build-arg BRANCH=$1 -t $NAME:$TAG .
else
	docker build --build-arg BRANCH=$1 -t $NAME:$TAG .
fi