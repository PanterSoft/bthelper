#!/bin/bash
sudo apt install autoconf libtool automake g++

./bootstrap.sh && ./configure && make && make install

sudo apt install bluez-tools
