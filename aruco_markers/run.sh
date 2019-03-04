#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)

mkdir -p markers
mkdir -p config

docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/markers/ \
    --opt o=bind \
    aruco_markers_markers_vol

docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/config/ \
    --opt o=bind \
    aruco_markers_config_vol

xhost +
docker run \
    --privileged \
	--net=host \
	-it \
	--env DISPLAY=${DISPLAY} \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="aruco_markers_markers_vol:/home/ros/ros_ws/src/aruco_markers/markers/:rw" \
	--volume="aruco_markers_config_vol:/home/ros/ros_ws/src/aruco_markers/config/:rw" \
	--volume="/dev/video0:/dev/video0" \
	$NAME:latest