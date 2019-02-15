FROM ros:indigo-ros-base
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y wget git vim bash-completion && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-latest.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

RUN apt-get update && apt-get install -y ros-indigo-orocos-kdl \
    ros-indigo-kdl-parser \ 
    ros-indigo-ros-control \
    ros-indigo-ros-controllers \
    ros-indigo-gazebo-ros \
    ros-indigo-gazebo-ros-pkgs \
    ros-indigo-eigen-conversions \
    ros-indigo-tf-conversions \
    libeigen3-dev \
	libncurses5-dev \
	libarmadillo-dev \    
    && rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1

# Now create the ros user itself
RUN adduser --gecos "ROS User" --disabled-password ros
RUN usermod -a -G dialout ros
ADD 99_aptget /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros
USER ros

# Change HOME environment variable
ENV HOME /home/ros

# installation
RUN mkdir -p ~/ros_ws/src
RUN cd ~/ros_ws/src && /bin/bash -c "source /ros_entrypoint.sh; catkin_init_workspace"
ARG BRANCH=master
RUN cd ~/ros_ws/src && git clone -b ${BRANCH} --single-branch https://github.com/epfl-lasa/kuka-lwr-ros.git

RUN cd ~/ros_ws/src && wstool init
RUN cd ~/ros_ws/src && wstool merge kuka-lwr-ros/dependencies.rosinstall
RUN cd ~/ros_ws/src && wstool update

RUN sudo apt-get update && rosdep update && rosdep install --from-paths -y ~/ros_ws/src --ignore-src --rosdistro indigo && sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws && /bin/bash -c "source /ros_entrypoint.sh; catkin_make"

# Change .bashrc
COPY update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ros /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY entrypoint.sh /ros_entrypoint.sh 
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ros /ros_entrypoint.sh ; 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]