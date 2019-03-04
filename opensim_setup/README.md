#OPENSIM_SETUP

This image includes an installation of the [Opensim library](https://github.com/opensim-org/opensim-core). It is built upon the [ros_setup](../ros_setup) image with the `melodic-ros-base` tag so make sure to have built it before. Both the [opensim-core](https://github.com/opensim-org/opensim-core) and the [opensim-gui](https://github.com/opensim-org/opensim-gui) are built on this image

The installation is time consuming but can be speed up by setting the number of cores on your computer in the `build.sh` script under the argument `NB_CORE`. The default value is 8.

At startup, the script `run.sh` mount a shared folder to store your models and programs to be compiled using Opensim.