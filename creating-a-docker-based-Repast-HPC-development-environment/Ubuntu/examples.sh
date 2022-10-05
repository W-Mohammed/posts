#!/bin/bash

# To run the examples:
## Use `docker run -it --rm -v ${PWD}:/project/mounted IMAGENAME` to mount the current directory to the container.
## Jump to the mounted folder `cd mounted`
## Run the Zomnies or Rumor example by calling `./examples.sh Zombies` or `./examples.sh Rumor`, respectively

# Zombies:
if [ $1 == Zombies ]
then
  echo "running the Zombies Repast HPC example:"
  echo " "
  echo "changing directory to '/project/examples/zombie'"
  cd /project/examples/zombie
  echo "starting the Zombies ABM model"
  echo " "
  echo "..... - ......"
  echo " "
  mpirun -n 4 ./zombie_model config.props model.props
  echo " "
  echo "..... - ......" 
  echo " "
  echo "finished running the Zombies ABM model"
  echo " "
fi

# Rumor:
if [ $1 == Rumor ]
then
  echo "running the Rumor Repast HPC example:"
  echo " "
  echo "changing directory to '/project/examples/rumor'"
  cd /project/examples/rumor
  echo "starting the Rumor ABM model"
  echo " "
  echo "..... - ......"
  echo " "
  mpirun -n 4 ./rumor_model config.props model.props
  echo " "
  echo "..... - ......" 
  echo " "
  echo "finished running the Rumor ABM model"
  echo " "
fi