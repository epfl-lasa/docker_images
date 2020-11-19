ARG BASE_IMAGE=osrf/ros
ARG BASE_TAG=melodic-desktop-full

FROM ${BASE_IMAGE}:${BASE_TAG}
ENV DEBIAN_FRONTEND=noninteractive

ENV QT_X11_NO_MITSHM 1

RUN apt update && apt install -y \
	wget \
	git \
	vim \
	bash-completion \
	build-essential \
	sudo \
	openssh-server \
	libignition-math2 \
	libignition-math2-dev \
	libboost-python-dev \
	mesa-utils \
	curl \
	apt-transport-https \
    ca-certificates \
    python-pip \
    ros-melodic-ros-controllers \
    && sudo apt upgrade -y \
	&& rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

RUN apt update && apt install -y \
	libgazebo9 \
	gazebo9 \
	gazebo9-plugin-base \
	libgazebo9-dev \
	&& apt upgrade -y libignition-math2 \
	&& rm -rf /var/lib/apt/lists/*

# Now create the same user as the host itself
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros
RUN usermod -a -G dialout ros
ADD config/99_aptget /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros
USER ros

# Change HOME environment variable
ENV HOME /home/ros

# install node
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
RUN source $HOME/.bashrc && nvm install 13.12.0
SHELL ["/bin/bash", "--login", "-c"]

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

# copy the external libraries
RUN mkdir -p ${HOME}/lib
WORKDIR ${HOME}/lib
# copy kuka_fri
COPY --chown=${USER} ./kuka_fri ${HOME}/lib/kuka_fri
WORKDIR ${HOME}/lib/kuka_fri
RUN ./waf configure
RUN ./waf
RUN sudo ./waf install

WORKDIR ${HOME}/lib
RUN git clone --recursive https://github.com/costashatz/SpaceVecAlg.git
WORKDIR ${HOME}/lib/SpaceVecAlg
RUN mkdir build
WORKDIR ${HOME}/lib/SpaceVecAlg/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SIMD=ON -DPYTHON_BINDING=OFF ..
RUN make -j
RUN sudo make install

WORKDIR ${HOME}/lib
RUN git clone --recursive https://github.com/costashatz/RBDyn.git
WORKDIR ${HOME}/lib/RBDyn
RUN mkdir build 
WORKDIR ${HOME}/lib/RBDyn/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SIMD=ON -DPYTHON_BINDING=OFF ..
RUN make -j
RUN sudo make install

WORKDIR ${HOME}/lib
RUN git clone --recursive https://github.com/costashatz/mc_rbdyn_urdf.git
WORKDIR ${HOME}/lib/mc_rbdyn_urdf
RUN mkdir build
WORKDIR ${HOME}/lib/mc_rbdyn_urdf/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SIMD=ON -DPYTHON_BINDING=OFF ..
RUN make -j
RUN sudo make install

WORKDIR ${HOME}/lib
RUN git clone https://github.com/mosra/corrade.git
WORKDIR ${HOME}/lib/corrade
RUN mkdir build
WORKDIR ${HOME}/lib/corrade/build
RUN cmake ..
RUN make -j
RUN sudo make install

WORKDIR ${HOME}/lib
RUN git clone https://github.com/epfl-lasa/robot_controllers.git
WORKDIR ${HOME}/lib/robot_controllers
RUN mkdir build
WORKDIR ${HOME}/lib/robot_controllers/build
RUN cmake ..
RUN make -j
RUN sudo make install

WORKDIR /home/${USER}/ros_ws/src
RUN git clone https://github.com/osrf/rvizweb.git

WORKDIR /home/${USER}/ros_ws/src
RUN rosdep update
RUN sudo apt update \
	&& rosdep install -r -y -q -n --from-paths . --ignore-src --rosdistro melodic \
	&& sudo rm -rf /var/lib/apt/lists/*

RUN pip install tornado pymongo

WORKDIR ${HOME}/ros_ws/
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN catkin_make install
SHELL ["/bin/bash", "--login", "-c"]

# create an overlay workspace for iiwa_ros
RUN mkdir -p ${HOME}/ros_overlay_ws/src
WORKDIR ${HOME}/ros_overlay_ws/src
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN catkin_init_workspace
SHELL ["/bin/bash", "--login", "-c"]

COPY --chown=${USER} ./iiwa_ros ${HOME}/ros_overlay_ws/src/iiwa_ros

WORKDIR /home/${USER}/ros_overlay_ws/src
RUN git clone -b melodic-devel --single-branch https://github.com/ros-controls/ros_control.git

COPY --chown=${USER} ./scripts/ ${HOME}/ros_overlay_ws/src/scripts
COPY --chown=${USER} ./models/ ${HOME}/ros_overlay_ws/src/models

WORKDIR /home/${USER}/ros_overlay_ws/src
RUN rosdep update
RUN sudo apt update \
	&& rosdep install -r -y -q -n --from-paths . --ignore-src --rosdistro melodic \
	&& sudo rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "--login", "-i", "-c"]
WORKDIR ${HOME}/ros_overlay_ws/
RUN source ~/ros_ws/install/setup.bash
RUN catkin_make
SHELL ["/bin/bash", "--login", "-c"]

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# source the environment
#COPY --chown=${USER} config/bash_aliases ${HOME}/.bash_aliases
USER root
COPY config/update_bashrc /sbin/update_bashrc
RUN chmod +x /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; rm /sbin/update_bashrc
USER ros

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]