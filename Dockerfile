# FROM osrf/ros:kinetic-desktop-full-xenial
FROM althack/ros2:humble-cuda-gazebo-nvidia-2023-02-15

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

RUN apt-get update && apt-get install -y libboost-all-dev libeigen3-dev

RUN sudo sh -c "echo 'deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub $(lsb_release -cs) robotpkg' >> /etc/apt/sources.list.d/robotpkg.list"
RUN curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add -
RUN sudo apt-get update && apt-get install robotpkg-py3*-eigenpy

ENV PYTHONPATH "${PYTHONPATH}:/opt/openrobots/lib/python3.10/site-packages/"

RUN pip3 install --upgrade qpsolvers[open_source_solvers] eiquadprog scipy

RUN apt-get install -qqy robotpkg-py3*-pinocchio robotpkg-py3*-example-robot-data

RUN apt-get install -qqy robotpkg-py3*-qt5-gepetto-viewer-corba+doc

ENV PATH "/opt/openrobots/bin:$PATH"
ENV PKG_CONFIG_PATH "/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH"
ENV LD_LIBRARY_PATH "/opt/openrobots/lib:$LD_LIBRARY_PATH"
ENV CMAKE_PREFIX_PATH "/opt/openrobots:$CMAKE_PREFIX_PATH"

# RUN adduser --disabled-password --gecos '' docker
RUN useradd -m docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

# setup entrypoint, need entrypoint.sh in the same folder with Dockerfile
COPY ./env_entrypoint.sh /
ENTRYPOINT ["/env_entrypoint.sh"]

CMD ["bash"]