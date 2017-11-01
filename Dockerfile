FROM i386/ubuntu:14.04
MAINTAINER lozovsky <lozovsky@apriorit.com>
RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    cmake \
    curl \
    dpkg \
    gcc \
    g++ \
    git \
    libboost-dev \
    libcurl4-openssl-dev \
    libyaml-cpp-dev \
    linux-headers-3.13.0-132-generic \
    linux-headers-3.16.0-77-generic \
    linux-headers-3.19.0-79-generic \
    linux-headers-4.2.0-42-generic \
    linux-headers-4.4.0-93-generic \
    rpm \
    sparse \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*
