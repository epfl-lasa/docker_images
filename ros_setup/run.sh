#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch to build the image with among:'
    echo '- master'
    echo '- dev_controllers'
    exit 0
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

xhost +
docker run \
	--ulimit rtprio=95:95 \
	--ulimit memlock=-1:-1 \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --device /dev/bus/usb:/dev/bus/usb:rwm \
    --env ROS_MASTER_URI=http://192.168.0.1:11311 \
    --env ROS_IP=192.168.0.1 \
	$NAME:$TAG