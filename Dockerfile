FROM justagist/ros2-cuda-with-cuda-toolkit:humble_base AS base

ENV ROS_DISTRO=humble

RUN apt-get update && apt-get install -q -y \
    build-essential git swig sudo python3-future libcppunit-dev python3-pip

RUN pip3 install --upgrade numpy numpy-quaternion

RUN apt-get update && apt-get upgrade -y

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# RUN adduser --disabled-password --gecos '' docker
RUN useradd -m docker
RUN adduser docker sudo
RUN adduser docker ros
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

# setup entrypoint, need entrypoint.sh in the same folder with Dockerfile
COPY ./env_entrypoint.sh /
ENTRYPOINT ["/env_entrypoint.sh"]

CMD ["bash"]