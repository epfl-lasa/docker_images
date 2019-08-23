NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

if [ -z "$TAG" ]; then
	TAG="latest"
fi

mkdir -p ros_ws

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros_ws/ \
    --opt o=bind \
    ${NAME}_ros_ws_vol

xhost +
docker run \
    --privileged \
	--net=host \
	-it \
	--env DISPLAY=${DISPLAY} \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
	--volume="${NAME}_ros_ws_vol:/home/ros/ros_ws/:rw" \
	${NAME}:${TAG}