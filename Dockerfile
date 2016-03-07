# This docker file contains build environment
FROM savoirfairelinux/ring-ubuntu32:14.04
MAINTAINER maliy.sergey <maliy.sergey@apriorit.com>
RUN apt-get update && apt-get install -y bison++ libssl-dev libxalan-c-dev libxerces-c-dev libprocps3-dev libnl-3-dev libcrypto++-dev libpcre++-dev uuid-dev libsnappy-dev build-essential libboost-all-dev cmake maven libicu-dev zlib1g-dev liblog4cpp5-dev libncurses5-dev libselinux1-dev wget libsqlite3-dev && wget http://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.gz && tar xf patchelf-0.8.tar.gz && patchelf-0.8/configure && make install && rm -rf patchelf-0.8 && rm -f patchelf-0.8.tar.gz
# Custom build of xalan-c lib
RUN cd /tmp && apt-get source libxalan-c111 && cd ./xalan-1.11/c/ && export XALANCROOT=/tmp/xalan-1.11/c && ./runConfigure -p linux -c gcc -x g++ -d && make && cp -pr ./lib/lib* /usr/lib/i386-linux-gnu/
