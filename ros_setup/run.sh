#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the ros distrib to use:'
    echo '- indigo'
    echo '- kinetic'
    echo '- melodic'
    exit 0
fi

mkdir -p ros_ws

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$1-desktop-full

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros_ws/ \
    --opt o=bind \
    ${NAME}_ros_ws_vol

xhost +
docker run \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="${NAME}_ros_ws_vol:/home/ros/ros_ws/:rw" \
	$NAME:$TAG