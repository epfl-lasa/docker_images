#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the ros distro to build the image on among:'
    echo '- melodic-ros-base'
    echo '- kinetic-ros-base'
    echo '- indigo-ros-base'
    echo '- other available on ros docker hub (not tested)'
    exit 0
fi

mkdir ros_ws

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros_ws/ \
    --opt o=bind \
    ros_ws_vol

xhost +
docker run \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="ros_ws_vol:/home/ros/ros_ws/:rw" \
	$NAME:$TAG