#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)
TAG="latest"

#create a shared volume to store the lib folder
docker volume create --driver local \
    --opt type="none" \
    --opt device="${PWD}/source/" \
    --opt o="bind" \
    "${NAME}_src_vol"

xhost +
docker run \
    --privileged \
	--net=host \
	-it \
	--rm \
	--volume="${NAME}_src_vol:/home/ros/ros_ws/src/:rw" \
	$NAME:$TAG