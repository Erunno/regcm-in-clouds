#!/bin/bash

# README
# This script builds necessary images and directories for running RegCM on Charlie Cloud.
# You will need to change the content of the ROOT_DIR variable to the path of this repository on your machine.
# You will need to have ch-image and ch-convert installed on your machine.
#    - In the case of `parlab` and `gpulab` (MFF cluster), you need to run the script on one of the worker nodes.


# root directory of the repository - change this to the path of the repository on your machine
ROOT_DIR=~/phd/atm_sym/in-cloud 

cd $ROOT_DIR

# create images from dockerfiles

dockerfiles=("almalinux_8ch" "libfabric" "openmpi" "regcm")

for dockerfile in "${dockerfiles[@]}"; do
    echo -e "\e[32mCreating image \e[35m$dockerfile\e[0m"
    ch-image build -f Dockerfile.$dockerfile .
done

# convert images to charlei cloud directory

echo -e "\e[32mConverting image \e[35mregcm\e[32m to directory imgdir\e[0m"
ch-convert -i ch-image -o dir regcm imgdir
