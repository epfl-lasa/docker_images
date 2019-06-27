NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

mkdir -p ros2_ws

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros2_ws/ \
    --opt o=bind \
    ros2_setup_ros2_ws_vol

xhost +
docker run \
    --runtime=nvidia \
    --privileged \
	--net=host \
	-it \
	--env DISPLAY=${DISPLAY} \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
	--volume="ros2_setup_ros2_ws_vol:/home/ros2/ros2_ws/:rw" \
	$NAME:latest