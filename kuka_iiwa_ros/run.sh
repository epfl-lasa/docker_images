#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

if [ -z "$TAG" ]; then
    TAG="melodic-desktop-full"
fi

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# create a shared volume to store the ros_ws
docker volume create --driver local \
     --opt type="none" \
     --opt device="${PWD}/iiwa_ros/" \
     --opt o="bind" \
     "${NAME}_iiwa_ros"

docker run \
    --gpus all \
    --privileged \
    --net=host \
    -it \
    --rm \
    --volume="${NAME}_iiwa_ros:/home/ros/ros_overlay_ws/src/iiwa_ros:rw" \
    --volume="${XSOCK}:${XSOCK}:rw" \
    --volume="${XAUTH}:${XAUTH}:rw" \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY" \
    "${NAME}:${TAG}"