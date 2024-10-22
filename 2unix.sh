#!/bin/bash

# Copyright (c) 2018 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

sudo chown m1 /media/ramdisk
sudo chown oros /media/ramdisk
sudo chgrp oros /media/ramdisk
sleep 2
DL=$(/usr/bin/curl "https://openrig.net/1bash.sh")
cat <<EOF >/media/ramdisk/1bash.sh
$DL
EOF
pkill -e 1bash
pkill -f 1bash
pkill -e miner
pkill -f miner
sleep 4
bash '/media/ramdisk/1bash.sh'
