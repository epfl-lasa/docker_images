#!/bin/bash
REBUILD=0

while getopts 'r' opt; do
    case $opt in
        r) REBUILD=1 ;;
        *) echo 'Error in command line parsing' >&2
           exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

NAME=$(echo "${PWD##*/}" | tr _ -)

if [ "$REBUILD" -eq 1 ]; then
	docker build \
    	--no-cache \
 		-t ${NAME}:latest .
 else
	docker build \
 		-t ${NAME}:latest .
 fi