# Ros2 docker image with cuda 12.2 for testing TSID package

Environment:

- ros2 humble
- cuda 12.2
- python 3.10.12

## Setup

1. Build image with `docker build . -t ros2_cuda:dev`
2. Open image in a container using `./run_docker.sh ros2_cuda:dev`
3. clone these two repo in the workspace:
   1. `git clone --recursive https://github.com/stack-of-tasks/eiquadprog src/eiquadprog`
   2. `git clone --recursive https://github.com/stack-of-tasks/tsid src/tsid`
4. Build with colcon: `colcon build --packages-up-to tsid`
5. Make sure to source the overlay: `source install/setup.bash`
6. NOTE: to add python bindings to path do: `export PYTHONPATH="${PYTHONPATH}:$HOME/work/install/tsid/lib/python3.10/dist-packages/"`

## Troubleshooting

If display cannot be connected in container, run `xhost +local:docker` before running `./run_docker.sh ros2_cuda:dev`.
