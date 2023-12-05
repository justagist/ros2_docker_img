#! /bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

# path where the catkin ws will be stored for the docker to use
HOST_WS_PATH="$HOME/projects/.container"

if ! [ -d "${HOST_WS_PATH}/src" ]; then
    mkdir -p ${HOST_WS_PATH}/src
fi

docker run -it \
       --runtime=nvidia --gpus all \
       --env="DISPLAY" \
       --network="host" \
       --privileged \
       --env="QT_X11_NO_MITSHM=1" \
       --volume="/home/$USER:/home/$USER" \
       --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
       --volume="${HOST_WS_PATH}:/home/$USER/work" \
       --workdir="/home/$USER/work/" \
       $1 \
       bash 

echo -e "\nBye the byee!\n"