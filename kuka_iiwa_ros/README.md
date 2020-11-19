# kuka_iiwa_ros

This image creates a ros workspace set up to control a KUKA IIWA robot. See [iiwa_ros](https://github.com/epfl-lasa/iiwa_ros) package for more details. The installation process relies on the [kuka_fri](https://github.com/epfl-lasa/kuka_fri) package that is private. It is included as a submodule that requires [ssh configured properly](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh).

To download the submodule simply run:

```bash
git submodule init && git submodule update
```

Then you can build the image as usual using:

```bash
sh build.sh
```

To run the simulation, thus gazebo, in the container requires a Nvidia graphic card on the computer with Nvidia graphic drivers installed and [Nvidia Container Toolkit](https://github.com/NVIDIA/nvidia-docker). The configuration is done in the `run.sh` script. Start it with:

```bash
sh run.sh
```

Once in the terminal you can try the installation with:

```bash
roslaunch iiwa_gazebo iiwa_gazebo.launch
```