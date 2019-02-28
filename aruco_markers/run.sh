#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)

mkdir markers
mkdir config

docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/markers/ \
    --opt o=bind \
    markers_vol

docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/config/ \
    --opt o=bind \
    config_vol

xhost +
docker run \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="markers_vol:/home/ros/ros_ws/src/aruco_markers/markers/:rw" \
	--volume="config_vol:/home/ros/ros_ws/src/aruco_markers/config/:rw" \
    --device /dev/bus/usb:/dev/bus/usb:rwm \
	$NAME:latest