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


QT_SOURCE="qt-everywhere-opensource-src-4.8.1"
QT_BUILD_DIR=/tmp/qt
QT_INSTALL_DIR=/opt/Qt

mkdir -p $QT_BUILD_DIR
mkdir -p $QT_BUILD_DIR/shadow
mkdir -p $QT_INSTALL_DIR

QTDIR=$QT_INSTALL_DIR
PATH=$QTDIR/bin:$PATH

FAST=-j$(expr $(cpu_count) + 1)

PATCH_DIR=/tmp/docker

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
wget http://download.qt.io/archive/qt/4.8/4.8.1/$QT_SOURCE.tar.gz
check_hash sha256sum $QT_SOURCE.tar.gz "ef851a36aa41b4ad7a3e4c96ca27eaed2a629a6d2fa06c20f072118caed87ae8"
check_hash sha1sum   $QT_SOURCE.tar.gz "a074d0f605f009e23c63e0a4cb9b71c978146ffc"
check_hash md5sum    $QT_SOURCE.tar.gz "7960ba8e18ca31f0c6e4895a312f92ff"
tar -zxf $QT_SOURCE.tar.gz

cd $QT_BUILD_DIR/shadow
$QT_BUILD_DIR/$QT_SOURCE/configure -prefix $QT_INSTALL_DIR -platform $QT_PLATFORM  \
    -opensource -shared -nomake docs -nomake examples -nomake demos -release -fast \
    -no-qt3support -webkit -no-javascript-jit -silent -continue -plugin-sql-sqlite \
    -plugin-sql-sqlite2 -qt-zlib -qt-libtiff -qt-libpng -qt-libmng -qt-libjpeg \
    -confirm-license

# Apply our patches onto Qt
# =========================

cd $QT_BUILD_DIR/$QT_SOURCE

patch -p1 --input="$PATCH_DIR/qt-0001-webkit-disable-javascript-jit.patch"

# WebKit uses some forward declarations of Glib objects which are not kept up to date.
# In this case, Glib has updated GMutex to be a union, but JSC thinks of it as a struct.
# Check whether the old definition works, if it doesn't then update WebKit definitions.
if ! gcc -fsyntax-only $(pkg-config --cflags glib-2.0) -x c - 2>&1 >/dev/null <<EOF
#include <glib.h>
typedef struct _GMutex _GMutex;
EOF
then
    patch -p1 --input="$PATCH_DIR/qt-0002-webkit-update-gobject-forward-declarations.patch"
fi

# Contrary to what is said in QtWebKit changelog, -Werror does *not* pass on x86
# with gcc 4.6 due to silly errors. Disable it to avoid breaking the build.
patch -p1 --input="$PATCH_DIR/qt-0003-webkit-disable-warnings-as-errors.patch"

# Build and install
# =================

cd $QT_BUILD_DIR/shadow
make $FAST
make $FAST install

# Cleanup
# =======

rm -rf $QT_BUILD_DIR
