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

docker run \
    --gpus all \
    --privileged \
    --net=host \
    -it \
    --rm \
    --volume="${XSOCK}:${XSOCK}:rw" \
    --volume="${XAUTH}:${XAUTH}:rw" \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY" \
    "${NAME}:${TAG}"