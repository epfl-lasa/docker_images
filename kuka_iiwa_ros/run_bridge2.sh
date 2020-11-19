NAME=$(echo "${PWD##*/}_main" | tr _ -)

#create a shared volume to store the source folder
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/config \
    --opt o=bind \
    ${NAME}config_vol

docker run \
    -it \
    --rm \
	--net=host \
	--env="ROS_MASTER_URI=$ROS_MASTER_URI" \
	--env="ROS_IP=$ROS_IP" \
	--volume="${NAME}_config_vol:/config/:rw" \
	osrf/ros:eloquent-ros1-bridge \
	sh /config/start_bridge2.sh
