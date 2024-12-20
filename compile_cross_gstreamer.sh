#!/usr/bin/env bash

set -ex

sourcePath=/home/developer/workspace

PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_CROSS_LINUX=$sourcePath/software/cross

cd $sourcePath

mkdir -vp $PACKAGE_COMPILE_DIR
mkdir -vp $INSTALL_PREFIX_CROSS_LINUX

##########################################################################################
# rk3568
cd $PACKAGE_COMPILE_DIR

git clone -b 1.20 --depth=1 https://gitlab.freedesktop.org/gstreamer/gstreamer.git

cd gstreamer && cp $sourcePath/docker_platformer/patches/gst_rk3568.txt .

meson --cross-file gst_rk3568.txt build_rk3568 \
    -Dgtk_doc=disabled \
    -Dtests=disabled \
    -Dexamples=disabled \
    --reconfigure \
    --prefix=$INSTALL_PREFIX_CROSS_LINUX/rk3568/gstreamer

ninja -C build_rk3568

meson install -C build_rk3568/

ninja -C build_rk3568 clean

##########################################################################################