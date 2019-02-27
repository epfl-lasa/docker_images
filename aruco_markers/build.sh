#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)
docker build --build-arg ROS_DISTRO=$1 -t $NAME:latest .