ARG DISTRIB=indigo
FROM ros-setup:${DISTRIB}-desktop-full
ENV DEBIAN_FRONTEND noninteractive

RUN sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-latest.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

ARG DISTRIB=indigo
RUN sudo apt-get update && sudo apt-get install -y ros-${DISTRIB}-orocos-kdl \
    ros-${DISTRIB}-kdl-parser \ 
    ros-${DISTRIB}-ros-control \
    ros-${DISTRIB}-ros-controllers \
    ros-${DISTRIB}-gazebo-ros \
    ros-${DISTRIB}-gazebo-ros-pkgs \
    ros-${DISTRIB}-eigen-conversions \
	ros-${DISTRIB}-tf-conversions \
	ros-${DISTRIB}-ridgeback-* \
	ros-${DISTRIB}-universal-robot \
    libeigen3-dev \
	libncurses5-dev \
	libarmadillo-dev \    
	&& sudo rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1
USER ros

ARG BRANCH=devel
RUN cd ~/ros_ws/src && git clone -b ${BRANCH} --single-branch https://github.com/epfl-lasa/ridgeback_ur5_controller.git

RUN cd ~/ros_ws/src && wstool init
RUN cd ~/ros_ws/src && wstool merge ridgeback_ur5_controller/dependencies.rosinstall
RUN cd ~/ros_ws/src && wstool update

# Copy local workspace
ENV HOME /home/${USER}
WORKDIR ${HOME}/ros_ws/
COPY --chown=${USER} ./source/packages/ ./src/ 

RUN sudo apt-get update && rosdep update --include-eol- && rosdep install --from-paths -y ~/ros_ws/src --ignore-src --rosdistro ${DISTRIB} && sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws && /bin/bash -c "source devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
