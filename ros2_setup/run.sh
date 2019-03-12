mkdir -p ros2_ws
mkdir -p ros2_overlay_ws

NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=$(echo "$1" | tr _/ -)

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros2_ws/ \
    --opt o=bind \
    ros2_setup_ros2_ws_vol

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/ros2_overlay_ws/ \
    --opt o=bind \
    ros2_setup_ros2_overlay_ws_vol

xhost +
docker run \
	--net=host \
	-it \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="ros2_setup_ros2_ws_vol:/home/ros2/ros2_ws/:rw" \
    --volume="ros2_setup_ros2_overlay_ws_vol:/home/ros2/ros2_overlay_ws/:rw" \
	$NAME:latest