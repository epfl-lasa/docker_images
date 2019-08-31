ARG DISTRIB=melodic
FROM ros-setup:${DISTRIB}-desktop-full
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN sudo apt-get update && sudo apt-get install -y \
	libarmadillo-dev \    
    && sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws/src && git clone https://github.com/alaurens/body_tracker_msgs.git
RUN cd ~/ros_ws/src && git clone https://github.com/buschbapti/human_tf_pub.git
RUN cd ~/ros_ws/src && git clone https://github.com/epfl-lasa/mocap_optitrack.git
RUN cd ~/ros_ws/src && git clone https://github.com/nbfigueroa/SVMGrad.git

COPY ./lib/ /home/${USER}/lib/
RUN sudo chown -R ${USER}:${USER} /home/${USER}/lib

RUN cd ~/lib/protocol_buffers && rm -rf build && mkdir build && cd build && cmake .. && make && sudo make install && sudo ldconfig
RUN cd ~/lib/state_representation && rm -rf build && mkdir build && cd build && cmake .. && make && sudo make install && sudo ldconfig
RUN cd ~/lib/dynamical_systems && rm -rf build && mkdir build && cd build && cmake .. && make && sudo make install && sudo ldconfig

COPY ./src/ergo_ds/ /home/${USER}/ros_ws/src/ergo_ds/
RUN sudo chown -R ${USER}:${USER} /home/${USER}/ros_ws/src/ergo_ds

RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]