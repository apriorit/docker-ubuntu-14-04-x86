#!/bin/bash

set -eux

ARCH=$1

case "$ARCH" in
    armel)
        QT_PLATFORM=linux-g++
        ;;
    i386)
        QT_PLATFORM=linux-g++-32
        ;;
    amd64)
        QT_PLATFORM=linux-g++-64
        ;;
    *)
        echo "Invalid architecture '$ARCH'. Valid choices are: armel, i386, amd64."
        exit 1
esac

function cpu_count() {
    cat /proc/cpuinfo | grep 'cpu cores' | awk -F":" '{print $2}' | head -n 1
}

function package_update() {
    sudo apt-get --yes update
}

function package_install() {
    sudo apt-get --yes install $@
}

function check_hash() {
    if [ "$($1 $2 | awk '{print $1}')" != "$3" ]
    then
        echo "$1 check failed for $2"
        exit 1
    fi
}


QT_SOURCE="qt-everywhere-opensource-src-4.8.7"
QT_BUILD_DIR=/tmp/qt
QT_INSTALL_DIR=/opt/Qt

mkdir -p $QT_BUILD_DIR
mkdir -p $QT_BUILD_DIR/shadow
mkdir -p $QT_INSTALL_DIR

QTDIR=$QT_INSTALL_DIR
PATH=$QTDIR/bin:$PATH

FAST=-j$(expr $(cpu_count) + 1)

# Install build prerequisites
# ===========================

package_update

# for general compiling
package_install build-essential wget

# for QT as documented in http://doc.qt.digia.com/qt/requirements-x11.html
package_install \
    libx11-dev \
    libfreetype6-dev \
    libxcursor-dev \
    libxext-dev \
    libxfixes-dev \
    libxft-dev \
    libxi-dev \
    libxrandr-dev \
    libxrender-dev

# Download and configure Qt distribution
# ======================================

cd $QT_BUILD_DIR
wget http://download.qt.io/archive/qt/4.8/4.8.7/$QT_SOURCE.tar.gz
check_hash sha256sum $QT_SOURCE.tar.gz "e2882295097e47fe089f8ac741a95fef47e0a73a3f3cdf21b56990638f626ea0"
check_hash sha1sum   $QT_SOURCE.tar.gz "76aef40335c0701e5be7bb3a9101df5d22fe3666"
check_hash md5sum    $QT_SOURCE.tar.gz "d990ee66bf7ab0c785589776f35ba6ad"
tar -zxf $QT_SOURCE.tar.gz

cd $QT_BUILD_DIR/shadow
$QT_BUILD_DIR/$QT_SOURCE/configure -prefix $QT_INSTALL_DIR -platform $QT_PLATFORM  \
    -opensource -shared -nomake docs -nomake examples -nomake demos -release -fast \
    -no-qt3support -webkit -no-javascript-jit -silent -continue -plugin-sql-sqlite \
    -plugin-sql-sqlite2 -qt-zlib -qt-libtiff -qt-libpng -qt-libmng -qt-libjpeg \
    -confirm-license

# Build and install
# =================

cd $QT_BUILD_DIR/shadow
make $FAST
make $FAST install

# Cleanup
# =======

rm -rf $QT_BUILD_DIR
