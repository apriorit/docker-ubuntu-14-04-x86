#!/bin/bash

cd /tmp
wget http://www.cmake.org/files/v2.8/cmake-2.8.8.tar.gz
tar xf cmake-2.8.8.tar.gz

cd cmake-2.8.8
./bootstrap
make
make install

cd /tmp
rm -r cmake-2.8.8 cmake-2.8.8.tar.gz
