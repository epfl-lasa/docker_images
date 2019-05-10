FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl gnupg2 lsb-release
RUN curl http://repo.ros2.org/repos.key | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN apt update && apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget \
  sudo \
  libasio-dev \
  libtinyxml2-dev \
  && rm -rf /var/lib/apt/lists/*
 
RUN python3 -m pip install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  git+https://github.com/lark-parser/lark.git@0.7d \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools

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

# create ros2 install workspace
RUN mkdir -p ~/ros2_ws/src
RUN cd ~/ros2_ws && wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos && vcs import src < ros2.repos
RUN sudo rosdep init && rosdep update
RUN sudo apt update && cd ~/ros2_ws && rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"
RUN cd ~/ros2_ws/ && colcon build --symlink-install

# create ros2 overlay workspace
RUN mkdir -p ~/ros2_overlay_ws/src && cd ~/ros2_overlay_ws/ && /bin/bash -c "source ~/ros2_ws/install/setup.bash; colcon build"

# set up environment
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ros2 /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh 
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ros2 /ros_entrypoint.sh ; 

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]