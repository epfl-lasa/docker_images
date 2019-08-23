FROM ros-setup:kinetic-desktop-full
ENV DEBIAN_FRONTEND noninteractive

USER ros

ENV QT_X11_NO_MITSHM 1

RUN cd ~/ros_ws/src && git clone https://github.com/alaurens/body_tracker_msgs.git
RUN cd ~/ros_ws/src && git clone https://github.com/buschbapti/human_tf_pub.git
RUN cd ~/ros_ws/src && git clone https://github.com/epfl-lasa/mocap_optitrack.git

#RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]