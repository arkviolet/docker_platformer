#!/usr/bin/env bash
set -ex

sourcePath=/home/developer/workspace

PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_CROSS_LINUX=$sourcePath/software/cross

cd $sourcePath

mkdir -vp $PACKAGE_COMPILE_DIR
mkdir -vp $INSTALL_PREFIX_CROSS_LINUX

# rk3568
PLATFORM=rk3568
source $sourcePath/linux_crosss_env/environment-setup.rk3568.sh

# linaro_arm
PLATFORM=linaro_arm
source $sourcePath/linux_crosss_env/environment-setup.linaro_arm.sh

##########################################################################################
# procps
cd $PACKAGE_COMPILE_DIR

git clone https://gitlab.com/procps-ng/procps.git

cd procps && ./autogen.sh 

./configure $CONFIGURE_FLAGS \
    --prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/procps \
    --enable-shared=no
    # linaro arm5.5 need --disable-shared --disable-libwrap


make -j8 && make install

make clean

##########################################################################################


##########################################################################################
# sysstat
cd $PACKAGE_COMPILE_DIR

git clone https://github.com/sysstat/sysstat.git

cd sysstat

./configure $CONFIGURE_FLAGS \
            --prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/sysstat

make -j8 && make install

make clean

##########################################################################################
