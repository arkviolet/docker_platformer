#!/usr/bin/env bash

set -ex

sourcePath=$(cd $(dirname $0) && pwd)

# shellcheck disable=SC2034
GIT_PATCH_DIR=$sourcePath/patches


PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_LINUX=/home/${USER}/software/3rdparty
INSTALL_PREFIX_CROSS_LINUX=/home/${USER}/software/cross_3rdparty

mkdir -vp $PACKAGE_COMPILE_DIR


#ncurses
cd $PACKAGE_COMPILE_DIR

wget  https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz

tar xvf ncurses-6.2.tar.gz && cd ncurses-6.2/

./configure $CONFIGURE_FLAGS \
    --with-shared \
    --prefix=$INSTALL_PREFIX_CROSS_LINUX/ncurses

make -j8 && make install

wget  https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz

tar xvf ncurses-5.7.tar.gz && cd ncurses-5.7/

# linaro_arm
source $sourcePath/../linux_crosss_env/environment-setup.linaro_arm.sh

./configure $CONFIGURE_FLAGS \
    --with-shared=no \
    --prefix=$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/ncurses

make -j8 && make install

cd $PACKAGE_COMPILE_DIR
export NCURSES_CFLAGS="-I$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/ncurses/include/ncurses -I$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/ncurses/include/"
export NCURSES_LIBS="-L$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/ncurses/lib -lncurses"


# minicom
cd $PACKAGE_COMPILE_DIR

wget https://fossies.org/linux/misc/minicom-2.9.tar.bz2

tar -xjvf  minicom-2.9.tar.bz2 && cd minicom-2.9/

# rk3568
source $sourcePath/../linux_crosss_env/environment-setup.rk3568.sh

./configure $CONFIGURE_FLAGS --prefix=$INSTALL_PREFIX_CROSS_LINUX/rk3568/minicom

make -j8 && make install
make clean