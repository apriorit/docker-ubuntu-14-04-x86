FROM i386/ubuntu:14.04
MAINTAINER lozovsky <lozovsky@apriorit.com>

RUN apt-get update \
    && apt-get install -y \
        gcc \
        g++ \
        nasm \
        yasm \
        libidn11-dev \
        libnss3-dev \
        libnspr4-dev \
        libgtk2.0-dev \
        libpulse-dev \
        chrpath \
        rpm \
        wget \
        xvfb \
        libasound2 \
        libasound2-dev \
        libcups2-dev \
        libpcsclite-dev \
        apt-utils \
        libx11-dev \
        libfreetype6-dev \
        libxcursor-dev \
        libxext-dev \
        libxfixes-dev \
        libxft-dev \
        libxi-dev \
        libxrandr-dev \
        libxrender-dev \
        libxv-dev \
        libxkbfile-dev \
        libxkbfile1 \
        libxkbfile-dev \
        squashfs-tools \
        desktop-file-utils \
        git-core \
        libssl-dev \
        libxinerama-dev \
        libxdamage-dev \
        libavutil-dev \
        libavcodec-dev \
        libpcap-dev \
        libgstreamer0.10-dev \
        libgstreamer-plugins-base0.10-dev \
        software-properties-common

# Copy our Docker scripts directory into the image
COPY docker/* /tmp/docker/

# Download, build, and install our custom dependencies
RUN /tmp/docker/install-qt.sh i386 \
    && /tmp/docker/install-cmake-2.8.8.sh \
    && /tmp/docker/install-makeself.sh \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y \
        gcc-8 \
        g++-8 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50 \
    && apt-get clean
