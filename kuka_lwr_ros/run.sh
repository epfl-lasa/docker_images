#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch of the image to run (e.g. master)'
    exit 0
fi

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
	kuka-lwr-ros-$1:latest