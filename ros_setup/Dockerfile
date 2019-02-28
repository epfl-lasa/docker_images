ARG ROS_DISTRO=melodic-ros-base
FROM ros:${ROS_DISTRO}
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget git vim bash-completion build-essential sudo && rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1

# Now create the ros user itself
RUN adduser --gecos "ROS User" --disabled-password ros
RUN usermod -a -G dialout ros
ADD config/99_aptget /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros
USER ros

# Change HOME environment variable
ENV HOME /home/ros

# workspace setup
RUN mkdir -p ~/ros_ws/src
RUN cd ~/ros_ws/src && /bin/bash -c "source /ros_entrypoint.sh; catkin_init_workspace"
RUN cd ~/ros_ws && /bin/bash -c "source /ros_entrypoint.sh; catkin_make"

# Change .bashrc
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ros /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh 
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ros /ros_entrypoint.sh ; 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]