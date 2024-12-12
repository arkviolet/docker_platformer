#!/usr/bin/env bash

set -ex

sourcePath=$(cd $(dirname $0) && pwd)

PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_CROSS_LINUX=$sourcePath/software/

cd $sourcePath

mkdir -vp $PACKAGE_COMPILE_DIR
mkdir -vp $INSTALL_PREFIX_CROSS_LINUX

##########################################################################################
# procps

cd $PACKAGE_COMPILE_DIR

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

git clone https://gitlab.com/procps-ng/procps.git

cd procps && ./autogen.sh 

./configure $CONFIGURE_FLAGS \
    --enable-shared=no \
    --prefix=$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/procps \
    --disable-nls \
    --disable-pidwait

make -j8 && make install
make clean

# rk3568
cd $PACKAGE_COMPILE_DIR

source $sourcePath/../linux_crosss_env/environment-setup.rk3568.sh

./configure $CONFIGURE_FLAGS \
            --prefix=$INSTALL_PREFIX_CROSS_LINUX/rk3568/procps \
            --enable-shared=no

make -j8 && make install
make clean

##########################################################################################
# minicom
cd $PACKAGE_COMPILE_DIR

wget https://fossies.org/linux/misc/minicom-2.9.tar.bz2

tar -xjvf  minicom-2.9.tar.bz2 && cd minicom-2.9/

# rk3568
source $sourcePath/../linux_crosss_env/environment-setup.rk3568.sh

./configure $CONFIGURE_FLAGS --prefix=$INSTALL_PREFIX_CROSS_LINUX/rk3568/minicom

make -j8 && make install
make clean

##########################################################################################
# sysstat
cd $PACKAGE_COMPILE_DIR

git clone https://github.com/sysstat/sysstat.git

cd sysstat

# linaro_arm
source $sourcePath/../linux_crosss_env/environment-setup.linaro_arm.sh

./configure $CONFIGURE_FLAGS --prefix=$INSTALL_PREFIX_CROSS_LINUX/linaro_arm/sysstat

make -j8 && make install
make clean

#rk3568
source $sourcePath/../linux_crosss_env/environment-setup.rk3568.sh

./configure $CONFIGURE_FLAGS --prefix=$INSTALL_PREFIX_CROSS_LINUX/rk3568/sysstat

make -j8 && make install

make clean

##########################################################################################
