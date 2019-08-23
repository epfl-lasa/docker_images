FROM ros-setup:kinetic-desktop-full
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN sudo apt-get update && sudo apt-get -y install ros-kinetic-moveit \
    ros-kinetic-trac-ik \
    ros-kinetic-urdfdom-py \
    ros-kinetic-eigen-conversions \
    ros-kinetic-roslint \
    ros-kinetic-joint-state-publisher \
    ros-kinetic-robot-state-publisher \
    python-pip \
    && sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws/src && git clone https://github.com/baxter-flowers/human_moveit_config.git
RUN cd ~/ros_ws/src && git clone https://github.com/buschbapti/handovers.git
RUN cd ~/ros_ws/src && git clone https://github.com/ros/xacro.git --branch indigo-devel --single-branch

RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

RUN pip install xmltodict
RUN pip install scipy==1.2.0

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]