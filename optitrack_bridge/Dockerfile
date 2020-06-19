FROM ros-setup:melodic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
ENV USER ros
ENV HOME /home/${USER}

ENV QT_X11_NO_MITSHM 1

RUN sudo apt update && sudo apt install -y \
  	ros-melodic-vrpn-client-ros \
  	&& sudo rm -rf /var/lib/apt/lists/*

WORKDIR ${HOME}/ros_ws/src
COPY --chown=${USER} ./source/ .
RUN cd ~/ros_ws && /bin/bash -c "source devel/setup.bash; catkin_make"

# change to the home root
WORKDIR ${HOME}

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]