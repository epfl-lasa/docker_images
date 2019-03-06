#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the ros distro to build the image on among:'
    echo '- melodic-ros-base'
    echo '- kinetic-ros-base'
    echo '- indigo-ros-base'
    echo '- other available on ros docker hub (not tested)'
    exit 0
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

UID="$(id -u $USER)"
GID="$(id -g $USER)"
docker build --build-arg ROS_DISTRO=$1 \
 	--build-arg UID=$UID \
 	--build-arg GID=$GID \
 	-t $NAME:$TAG .