# Docker Open Broadcaster Software (OBS)

This container is running on ubuntu. The OBS is incorporated into the container with obs-ndi-plugin installed and can be used to stream your desktop over ndi.

## To run

You can start the container with:

`docker run --shm-size=256m -it -p 5901:5901 -e jbabin91/docker-obs-ndi`

The shm-size argument is to make sure that the webclient doesn't run out of shared memory for the container and crash.
