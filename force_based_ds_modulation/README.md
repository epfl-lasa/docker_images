#FORCE_BASED_DS_MODULATION

This image includes the package [force_based_ds_modulation](https://github.com/epfl-lasa/force_based_ds_modulation) developped at LASA-EPFL.

It is built upon [kuka_lwr_ros](../kuka_lwr_ros) image with the tag `dev_controllers` so be sure to have it built on your computer.

You can build and run a specific branch of the [force_based_ds_modulation](https://github.com/epfl-lasa/force_based_ds_modulation) package by passing it as argument of both `build.sh` and `run.sh` scripts.

The `run.sh` scripts creates a shared folder `data` on the host machine where output of the [force_based_ds_modulation](https://github.com/epfl-lasa/force_based_ds_modulation) are stored.