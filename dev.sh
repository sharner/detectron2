#!/usr/bin/env bash

if [ -z "$CONT_VERSION" ]
then
  CONT_VERSION=latest
fi

if [ -z "$BASE" ]
then
  BASE=torch
fi

# DETERMINE IF GPU IS AVAILABLE
if [ -z "$USE_GPU" ]
then
  echo "Using CPU"
  GPU=""
  GPU_FLAGS=""
else
  echo "Using GPU"
  GPU="-gpu" # "" or "gpu"
  GPU_FLAGS="--gpus all"
fi

export GROUP_ID=1004

# DETERMINE IF GPU IS AVAILABLE
echo "Using ${BASE} ${GPU} ${NETWORK}"

d2_build() {
  docker build --no-cache \
    --build-arg USER_ID=$(id -u) \
    --build-arg GROUP_ID=$(id -g) \
    -f Dockerfile.torch-d2 \
    -t lj-dev-container-gpu-d2:${CONT_VERSION} .
  echo "Done building lj-dev-container-gpu-d2:${CONT_VERSION}"
}

NETWORK="--network host"

d2_bash() {
  echo "Starting lj-dev-container-gpu-d2:${CONT_VERSION}"
  docker run ${GPU_FLAGS} \
    --mount type=bind,source="${LAYERJOT_HOME}",target=/layerjot \
    --mount type=bind,source="/data",target=/data \
    --shm-size 8G \
    --rm ${NETWORK} -it lj-dev-container-gpu-d2:${CONT_VERSION} bash	
}
