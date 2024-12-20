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
PLATFORM=rk3568
source $sourcePath/linux_crosss_env/environment-setup.rk3568.sh

# gdb
cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/gmp/gmp-6.1.2.tar.xz

tar -xvf gmp-6.1.2.tar.xz && cd gmp-6.1.2

./configure $CONFIGURE_FLAGS \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--exec-prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--sysconfdir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/etc \
		--localstatedir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/var

make -j8 && make install

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/libgmp.la

cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/mpfr/mpfr-4.0.1.tar.gz

tar -xvf mpfr-4.0.1.tar.gz && cd mpfr-4.0.1/

./configure $CONFIGURE_FLAGS \
		--enable-thread-safe \
		--enable-warnings \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--exec-prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--sysconfdir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/etc \
		--localstatedir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/var

make -j8 && make install

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/libmpfr.la

cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/mpc/mpc-1.1.0.tar.gz

tar -xvf mpc-1.1.0.tar.gz && cd mpc-1.1.0/

./configure $CONFIGURE_FLAGS \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpfr=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--exec-prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--sysconfdir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/etc \
		--localstatedir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/var

make -j8 && make install

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/libmpc.la

cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/gdb/gdb-8.1.tar.gz

tar -xvf gdb-8.1.tar.gz && cd gdb-8.1/

./configure $CONFIGURE_FLAGS \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpfr=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpc=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--enable-host-shared \
		--enable-vtable-verify \
		--enable-lto \
		--enable-libssp \
		--enable-libada \
		--program-suffix=8.1 \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/gun \
		--exec-prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--sysconfdir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/etc \
		--localstatedir=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun/var

sed -i '179,181d' gdb/nat/linux-ptrace.h

make -j8 && make install

make clean

##########################################################################################
# linaro_arm
PLATFORM=linaro_arm
source $sourcePath/linux_crosss_env/environment-setup.linaro_arm.sh

# gdb
cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/gmp/gmp-6.0.0a.tar.xz

tar -xvf gmp-6.0.0a.tar.xz && cd gmp-6.0.0

./configure $CONFIGURE_FLAGS \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--enable-cxx \
		--enable-fft

make -j8 && make install

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/lib*.la

cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/mpfr/mpfr-3.1.3.tar.xz

tar -xvf mpfr-3.1.3.tar.xz && cd mpfr-3.1.3/

./configure $CONFIGURE_FLAGS \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun

make -j8 && make install

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/lib*.la

cd $PACKAGE_COMPILE_DIR

wget http://mirrors.ustc.edu.cn/gnu/mpc/mpc-1.0.3.tar.gz

tar -xvf mpc-1.0.3.tar.gz && cd mpc-1.0.3/

./configure $CONFIGURE_FLAGS \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpfr=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun

make -j8 && make install

cd $PACKAGE_COMPILE_DIR

rm $INSTALL_PREFIX_CROSS_LINUX/gun/lib/lib*.la

wget http://mirrors.ustc.edu.cn/gnu/gdb/gdb-8.0.tar.gz

tar -xvf gdb-8.0.tar.gz && cd gdb-8.0/

./configure $CONFIGURE_FLAGS \
		--prefix=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-gmp=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpfr=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--with-mpc=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/gun \
		--program-suffix=8.0 \
		--with-gnu-ld \
		--enable-plugins \
		--enable-tui \
		--with-pkgversion=Linaro_GDB-2017.10 \
		--disable-gas \
		--disable-binutils \
		--disable-ld \
		--disable-gold \
		--disable-gprof \
		--without-curses \
		--enable-tui=no	\
		--exec-prefix=$INSTALL_PREFIX_CROSS_LINUX/gun \
		--sysconfdir=$INSTALL_PREFIX_CROSS_LINUX/gun/etc \
		--localstatedir=$INSTALL_PREFIX_CROSS_LINUX/gun/var

make -j8 && make install

make clean

##########################################################################################
