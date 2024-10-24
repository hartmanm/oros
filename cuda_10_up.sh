#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

V="18.04"
[[ $V == "16.04" ]] && cd /home/m1
[[ $V == "18.04" ]] && cd /home/oros
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0/7fa2af80.pub
sudo apt-get update -y
sudo apt-get install cuda-libraries-10-0 -y
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64 && sudo ldconfig
sudo apt update -y
sudo apt upgrade -y
