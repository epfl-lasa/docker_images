NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

UID="$(id -u $USER)"
GID="$(id -g $USER)"
docker build \
 	--build-arg UID=$UID \
 	--build-arg GID=$GID \
 	-t $NAME:latest .