FROM ros2-setup
ENV DEBIAN_FRONTEND=noninteractive

#RUN sudo apt update &&  sudo apt-get install -y software-properties-common
#RUN sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl


RUN sudo apt update &&  sudo apt install -y \
  libpcl-dev \
  ros-$ROS_DISTRO-cv-bridge ros-$ROS_DISTRO-librealsense2 ros-$ROS_DISTRO-message-filters ros-$ROS_DISTRO-image-transport \
  libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev \
  libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev \
  ros-$ROS_DISTRO-realsense-camera-msgs ros-$ROS_DISTRO-realsense-ros2-camera \
  && sudo rm -rf /var/lib/apt/lists/*


RUN cd ~/ros2_ws/src && git clone https://github.com/intel/ros2_intel_realsense.git
RUN cd ~/ros2_ws && /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; colcon build --base-paths src/ros2_intel_realsense" 

COPY ./packages/EPFL_color_segmentation /home/ros2/ros2_ws/src/EPFL_color_segmentation
RUN sudo chown -R ${USER}:${USER} ~/ros2_ws/src/EPFL_color_segmentation

# create ros2 overlay workspace
RUN cd ~/ros2_ws/ && /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; colcon build"


ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]