FROM ros-setup:kinetic-ros-base
ENV DEBIAN_FRONTEND noninteractive


RUN sudo apt-get update && sudo apt-get install -y \ 
    ros-kinetic-libfranka \
    ros-kinetic-franka-ros \
    && sudo rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1
USER ros

RUN sudo apt-get update && rosdep update && rosdep install --from-paths -y ~/ros_ws/src --ignore-src --rosdistro indigo && sudo rm -rf /var/lib/apt/lists/*

RUN cd ~/ros_ws && /bin/bash -c "source devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]