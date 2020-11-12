#!/bin/bash
ROS_VERSION="melodic"
BASE_IMAGE="osrf/ros"
BASE_TAG="${ROS_VERSION}-desktop"

docker pull "${BASE_IMAGE}:${BASE_TAG}"

docker network inspect isolated >/dev/null 2>&1 || docker network create --driver bridge isolated

docker run \
    -it \
    --name="roscore" \
    --hostname="roscore" \
    --privileged \
    --net=isolated \
    --rm \
    "${BASE_IMAGE}:${BASE_TAG}" \