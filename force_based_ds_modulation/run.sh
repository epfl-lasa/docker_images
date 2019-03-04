#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch to build the image with among:'
    echo '- master'
    echo '- features/rss'
    exit 0
fi

mkdir data

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

# create a shared volume to store the generate logs
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/data/ \
    --opt o=bind \
    forced_based_ds_modulation_data_vol

xhost +
docker run \
	--ulimit rtprio=95:95 \
	--ulimit memlock=-1:-1 \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="forced_based_ds_modulation_data_vol:/home/ros/ros_ws/src/force_based_ds_modulation/data:rw" \
    --env ROS_MASTER_URI=http://192.168.0.1:11311 \
    --env ROS_IP=192.168.0.1 \
	$NAME:$TAG