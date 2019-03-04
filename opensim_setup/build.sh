#!/bin/bash
NAME=$(echo "${PWD##*/}" | tr _ -)
docker build --build-arg NB_CORE=8 -t $NAME:latest .