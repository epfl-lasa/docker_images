#!/bin/bash
if [ $# -eq 0 ] ; then
    echo 'Specifiy the branch to build the image with (e.g. master)'
    exit 0
fi

docker build --build-arg BRANCH=$1 -t kuka-lwr-ros-$1:latest .