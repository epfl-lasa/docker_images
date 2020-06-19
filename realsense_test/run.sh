NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

xhost +
docker run \
    --privileged \
	--net=host \
	-it \
	--rm \
	--env DISPLAY=${DISPLAY} \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
	--device=/dev/dri:/dev/dri \
	-v /dev/video \
	$NAME:latest
