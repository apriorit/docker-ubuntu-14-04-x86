#!/bin/bash

set -eux

cd /tmp
wget http://megastep.org/makeself/makeself-2.1.5.run
chmod 755 makeself-2.1.5.run
./makeself-2.1.5.run
cd makeself-2.1.5
cp *.sh /usr/bin
cp makeself.sh /usr/bin/makeself
