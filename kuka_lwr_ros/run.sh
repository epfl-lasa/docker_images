#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=master-ros-kinetic-walid

xhost +
docker run \
	--ulimit rtprio=95:95 \
	--ulimit memlock=-1:-1 \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env ROS_MASTER_URI=http://192.168.0.1:11311 \
    --env ROS_IP=192.168.0.1 \
	$NAME:$TAG