# UR5_ROS
This image is the base one to connect and use the Kuka LWR and uses the package [ur_ros](https://github.com/epfl-lasa/ridgeback_ur5_controller) developped at LASA-EPFL.

It is built upon [ros_setup](../ros_setup) image with the tag `indigo-ros-base` so be sure to have it built on your computer.

You can build and run a specific branch of the [ur_ros](https://github.com/epfl-lasa/kuka-lwr-ros) package by passing it as argument of both `build.sh` and `run.sh` scripts.
