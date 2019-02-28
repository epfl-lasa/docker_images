# ROS_SETUP

This Docker image creates a functionnal ros environment based on the distribution of your choice. Visit [the official ros docker hub](https://hub.docker.com/_/ros) for a list of available distributions. To build an image simply use the script `build.sh` with the desired distribution as parameter:

```console
$ build.sh desired_distrib
```

The environment can then be accessed by running the script `run.sh` again with the distribution as parameter:

```console
$ run.sh desired_distrib
```

This creates an interactive console as a `ros` user with all the environment variables set in container. The script `run.sh` also creates the `ros_ws` folder as a shared volume on the host machine, allowing you to download packages and build them within the container. The ros workspace is compiled as with a normal installation (if you run the commands in the iteractive container).

You can spawn multiple interactive shell on the same container by simply running the script `run.sh` in a new terminal. You can also pass environment variable such `ROS_IP` or `ROS_MASTER_URI` by modifying the script.

If you need to install system libraries on the container we recommand you to create a new Docker image on top of the `res-setup` one with the distribution of your choice as image tag.