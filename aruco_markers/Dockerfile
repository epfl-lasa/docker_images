FROM ros-setup:melodic-ros-base
ENV DEBIAN_FRONTEND noninteractive

ENV QT_X11_NO_MITSHM 1
USER ros

RUN sudo apt-get update && sudo apt-get install -y build-essential \
	libgtk2.0-dev \
	pkg-config \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libtbb2 \
	libtbb-dev \
	libjpeg-dev \
	libpng-dev \ 
	libtiff-dev \
	libdc1394-22-dev \
	&& sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws/src && git clone https://github.com/epfl-lasa/aruco_markers.git
RUN cd ~/ros_ws/src/aruco_markers && git submodule update --init
RUN cd ~/ros_ws/src/aruco_markers/lib/opencv \
	&& mkdir build \
	&& cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules ..

ARG NB_PROCESS=8
RUN cd ~/ros_ws/src/aruco_markers/lib/opencv/build && make -j${NB_PROCESS}
RUN cd ~/ros_ws/src/aruco_markers/lib/opencv/build && sudo make install

RUN cd ~/ros_ws && /bin/bash -c "source devel/setup.bash; catkin_make"

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]