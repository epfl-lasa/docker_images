FROM ros-setup:melodic-ros-base
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN sudo apt-get update && sudo apt-get -y install ros-melodic-moveit \ 
	ros-melodic-roslint \
	ros-melodic-joint-state-publisher \
	ros-melodic-robot-state-publisher \
    ros-melodic-trac-ik \
    ros-melodic-urdfdom-py \
    ros-melodic-eigen-conversions \
    python-pip \
    && sudo rm -rf /var/lib/apt/lists/*

ARG DUMMY=unknown
#RUN DUMMY=${DUMMY} cd ~/ros_ws/src && git clone https://github.com/baxter-flowers/human_moveit_config.git
RUN DUMMY=${DUMMY} cd ~/ros_ws/src && git clone https://github.com/ros/xacro.git --branch indigo-devel --single-branch
RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

RUN pip install xmltodict


# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]