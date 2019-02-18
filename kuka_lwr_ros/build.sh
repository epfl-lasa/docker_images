#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch to build the image with among:'
    echo '- master'
    echo '- dev_controllers'
    exit 0
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)
docker build --build-arg BRANCH=$1 -t $NAME:$TAG .