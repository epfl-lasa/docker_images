# docker_images
Docker images used at LASA. Each folder contains a separate docker images. To build the images, ensure that you have docker set up and running (see [Docker documentation](https://docs.docker.com/install/)) and run the build script:

```
sh build.sh
```

For some images, you might need to specify which branch you want to pull. In this case run as follow:

```
sh build.sh myBranch
```

Image folders also include a `run.sh` script, that creates an interactive shell within the container. It also set up the environment variables and shared volumes necessary to use the image properly. See the `README` sections in the folder of the specific images for additional details.

Most of the image are based on the [ros_setup](./ros_setup) one which creates a functionnal ros environment.
