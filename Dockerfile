FROM i386/ubuntu:14.04
MAINTAINER buksha <buksha.dmitry@apriorit.com>

RUN apt-get update
RUN apt-get install -y build-essential software-properties-common git cmake3 xsltproc chrpath libssl-dev libx11-dev libxext-dev libxinerama-dev
RUN apt-get install -y libxcursor-dev libxdamage-dev libxv-dev libxkbfile-dev libasound2-dev libcups2-dev libxml2 libxml2-dev libpcsclite-dev
RUN apt-get install -y libxrandr-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libxi-dev libgstreamer-plugins-base1.0-dev
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y gcc-5 g++-5
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
