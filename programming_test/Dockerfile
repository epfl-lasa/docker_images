FROM ros-setup:melodic-ros-base
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN sudo apt-get update && sudo apt-get -y install \
	ros-melodic-turtlesim \
    && sudo rm -rf /var/lib/apt/lists/*

ARG DUMMY=unknown
#RUN DUMMY=${DUMMY} cd ~/ros_ws/src && git clone

RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]