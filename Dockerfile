FROM i386/ubuntu:14.04
MAINTAINER lozovsky <lozovsky@apriorit.com>

RUN apt-get update
RUN apt-get install -y nasm yasm libidn11-dev libnss3-dev libnspr4-dev libgtk2.0-dev libpulse-dev chrpath rpm wget xvfb
RUN apt-get install -y libasound2 libasound2-dev libcups2-dev libpcsclite-dev apt-utils libx11-dev libfreetype6-dev libxcursor-dev
RUN apt-get install -y libxext-dev libxfixes-dev libxft-dev libxi-dev libxrandr-dev libxrender-dev 
RUN apt-get install -y libxkbfile1 libxkbfile-dev squashfs-tools desktop-file-utils git-core libssl-dev libxinerama-dev libxdamage-dev libxv-dev libxkbfile-dev
RUN apt-get install -y libavutil-dev libavcodec-dev libpcap-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev

# Copy our Docker scripts directory into the image
COPY docker/* /tmp/docker/

# Download, build, and install our custom dependencies
RUN /tmp/docker/install-qt.sh i386
RUN /tmp/docker/install-cmake-2.8.8.sh
RUN /tmp/docker/install-makeself.sh
