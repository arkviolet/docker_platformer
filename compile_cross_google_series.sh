#!/usr/bin/env bash
set -ex

sourcePath=/home/developer/workspace

PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_LINUX=$sourcePath/software/x86_64
INSTALL_PREFIX_CROSS_LINUX=$sourcePath/software/cross
GIT_PATCH_DIR=$sourcePath/docker_platformer/patches

cd $sourcePath

mkdir -vp $PACKAGE_COMPILE_DIR
mkdir -vp $INSTALL_PREFIX_CROSS_LINUX

# rk3568
PLATFORM=rk3568
TOOLCHAIN_FILE=$sourcePath/linux_crosss_env/rk3568.cmake

# linaro_arm
PLATFORM=linaro_arm
TOOLCHAIN_FILE=$sourcePath/linux_crosss_env/linaro_arm.cmake

##########################################################################################
# glog

# gflags

# gtest

# protobuf

# grpc
cd $PACKAGE_COMPILE_DIR

git clone --recurse-submodules -b v1.50.1 --depth 1 --shallow-submodules https://github.com/grpc/grpc

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_x86_64 && cd build_x86_64

cmake .. -DgRPC_INSTALL=ON \
         -DgRPC_BUILD_TESTS=OFF \
         -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_LINUX/grpc

make -j8 && make install

make clean

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_$PLATFORM && cd build_$PLATFORM

cmake .. -DgRPC_INSTALL=ON \
		-DgRPC_BUILD_TESTS=OFF  \
		-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_CROSS_LINUX/$PLATFORM/grpc \
		-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE \
		-D_gRPC_CPP_PLUGIN=$INSTALL_PREFIX_LINUX/grpc/bin/grpc_cpp_plugin \
		-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=$INSTALL_PREFIX_LINUX/grpc/bin/protoc

# linaro_arm 5.5 need patch
# git apply -p1 --ignore-space-change --whitespace=nowarn GIT_PATCH_DIR/grpc_h3_r258.patch

make -j8 && make install

make clean
