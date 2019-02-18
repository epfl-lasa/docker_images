FROM kuka-lwr-ros:dev-controllers
ENV DEBIAN_FRONTEND noninteractive

# Choose to run as user
USER ros

ARG DUMMY=unknown
ARG BRANCH=master
RUN DUMMY=${DUMMY} cd ~/ros_ws/src && git clone -b ${BRANCH} --single-branch https://github.com/epfl-lasa/force_based_ds_modulation.git
RUN cd ~/ros_ws/src && git clone https://github.com/epfl-lasa/gaussian-process-regression.git

RUN cd ~/ros_ws/src && wstool merge force_based_ds_modulation/dependencies.rosinstall
RUN cd ~/ros_ws/src && wstool update

RUN sudo apt-get update && rosdep update && rosdep install --from-paths -y ~/ros_ws/src --ignore-src --rosdistro indigo && sudo rm -rf /var/lib/apt/lists/*

RUN cd  ~/ros_ws/src/libsvm && make
#ENV PATH=${PATH}:/home/ros/ros_ws/src/libsvm

RUN cd ~/ros_ws && /bin/bash -c "source ~/ros_ws/devel/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]