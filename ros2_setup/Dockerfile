FROM osrf/ros2:nightly
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  sudo \
  git \
  && rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1

# Now create the same user as the host itself
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros2
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros2
RUN usermod -a -G dialout ros2
ADD config/99_aptget /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros2
USER ros2

# Change HOME environment variable
ENV HOME /home/ros2

# create ros2 overlay workspace
RUN mkdir -p ~/ros2_ws/src && cd ~/ros2_ws/ && /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; colcon build"

# set up environment
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ros2 /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh 
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ros2 /ros_entrypoint.sh ; 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]