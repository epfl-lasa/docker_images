FROM ros-setup:melodic-ros-base
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN sudo apt-get update && sudo apt-get -y install freeglut3-dev \
    libxi-dev \
    libxmu-dev \
    liblapack-dev \
    swig \
    openjdk-8-jdk \
    mesa-utils \
    libglvnd0 \
    libgl1-mesa-glx \
    && sudo rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ARG NB_CORE=8
RUN cd ~ && git clone https://github.com/opensim-org/opensim-core.git
RUN cd ~ && mkdir opensim_dependencies_build && cd opensim_dependencies_build \
	&& cmake ../opensim-core/dependencies/ \
      -DCMAKE_INSTALL_PREFIX='~/opensim_dependencies_install' \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    && make -j${NB_CORE}

RUN cd ~ && mkdir opensim_build && cd opensim_build \
	&& cmake ../opensim-core \
      -DCMAKE_INSTALL_PREFIX="~/opensim_install" \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DOPENSIM_DEPENDENCIES_DIR="~/opensim_dependencies_install" \
      -DBUILD_PYTHON_WRAPPING=ON \
      -DBUILD_JAVA_WRAPPING=ON \
      -DWITH_BTK=ON \
	&& make -j${NB_CORE} \
	&& make -j${NB_CORE} install

RUN cd ~ && git clone https://github.com/RealTimeBiomechanics/Filter.git \
  && cd Filter \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j${NB_CORE} \
  && sudo make -j${NB_CORE} install

RUN cd ~ && git clone https://github.com/SoryaJullien/Concurrency.git \
  && cd Concurrency \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j${NB_CORE} \
  && sudo make -j${NB_CORE} install

ENV PATH=~/opensim_install/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ros/opensim_install/lib
ENV OPENSIM_HOME=/home/ros/opensim_install

RUN cd ~ && git clone https://github.com/SoryaJullien/rtosim.git \
  && cd rtosim \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j${NB_CORE} \
  && sudo make -j${NB_CORE} install


# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq xserver-xorg-video-all && sudo rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]