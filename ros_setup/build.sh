#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the ros distro to build the image on among:'
    echo '- melodic-ros-base'
    echo '- kinetic-ros-base'
    echo '- indigo-ros-base'
    exit 0
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)
docker build --build-arg ROS_DISTRO=$1 -t $NAME:$TAG .