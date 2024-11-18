#!/bin/bash

# README
# This script builds necessary images and directories for running RegCM on Charlie Cloud.
# You will need to change the content of the ROOT_DIR variable to the path of this repository on your machine.
# You will need to have ch-image and ch-convert installed on your machine.
#    - In the case of `parlab` and `gpulab` (MFF cluster), you need to run the script on one of the worker nodes.
# Optional inpur arguments:
#    - `--use-local-repo` use the local repository for building the images. 
#                         The repo has to present in the ROOT_DIR/RegCM.
#    - `--commit-id=<commit_id>` use the commit ID for building the RegCM.
#    - `--skip-env-images` skip building the environment images (almalinux_8ch, libfabric, openmpi, regcm-env).
#
# Example: ./install.sh --use-local-repo --skip-env-images
#


# root directory of the repository - change this to the path of the repository on your machine
ROOT_DIR=~/phd/atm_sym/in-cloud 

cd $ROOT_DIR

USE_LOCAL_REPO_OPT=""
COMMIT_ID_OPT=""
SKIP_ENV_IMAGES=false

for arg in "$@"; do
    if [ "$arg" == "--use-local-repo" ]; then
        USE_LOCAL_REPO_OPT="--build-arg USE_LOCAL_REPO=true"
    elif [[ "$arg" == --commit-id=* ]]; then
        COMMIT_ID_OPT="--build-arg COMMIT_ID=${arg#*=}"
    elif [ "$arg" == "--skip-env-images" ]; then
        SKIP_ENV_IMAGES=true
    fi
done

if [ -n "$USE_LOCAL_REPO_OPT" ]; then
    echo -e "\e[32mUsing local repository for building \e[35mRegCM\e[0m"
fi

if [ "$SKIP_ENV_IMAGES" = true ]; then
    echo -e "\e[32mSkipping building environment images - \e[35malmalinux_8ch\e[32m, \e[35mlibfabric\e[32m, \e[35mopenmpi\e[32m and \e[35mregcm-env\e[32m\e[0m"
fi

if [ -n "$COMMIT_ID_OPT" ]; then
    echo -e "\e[32mUsing build parameter: \e[35m$COMMIT_ID_OPT\e[0m\n"
fi

echo

if [ ! -d "RegCM" ]; then
    mkdir RegCM
fi

# create images from dockerfiles

if [ "$SKIP_ENV_IMAGES" = false ]; then
    dockerfiles=("almalinux_8ch" "libfabric" "openmpi" "regcm-env")

    for dockerfile in "${dockerfiles[@]}"; do
        echo -e "\e[32mCreating image \e[35m$dockerfile\e[0m"
        ch-image build -f Dockerfile.$dockerfile .
    done
fi

echo -e "\e[32mCompiling \e[35mRegCM\e[0m"
ch-image build -f Dockerfile.regcm $USE_LOCAL_REPO_OPT $COMMIT_ID_OPT .

# convert images to charlei cloud directory

echo -e "\e[32mConverting image \e[35mregcm\e[32m to directory \e[35mimgdir\e[0m"
ch-convert -i ch-image -o dir regcm imgdir
