#!/usr/bin/env bash

set -ex

sourcePath=$(cd $(dirname $0) && pwd)

# shellcheck disable=SC2034
GIT_PATCH_DIR=$sourcePath/patches

INSTALL_PREFIX_LINUX=$sourcePath/toolkit_3rd
INSTALL_PREFIX_CROSS_LINUX_RK3568=$sourcePath/toolkit_3rd_rk3568
INSTALL_PREFIX_CROSS_LINUX_H3_R258=$sourcePath/toolkit_3rd_h3_r258

PACKAGE_COMPILE_DIR=$sourcePath/packages

mkdir -vp $PACKAGE_COMPILE_DIR

# grpc
cd $PACKAGE_COMPILE_DIR

git clone --recurse-submodules -b v1.50.1 --depth 1 --shallow-submodules https://github.com/grpc/grpc

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build && cd build

cmake .. -DgRPC_INSTALL=ON \
         -DgRPC_BUILD_TESTS=OFF \
         -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_LINUX/grpc

make -j8 && make install

# rk3568
cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_rk3568 && cd build_rk3568

cmake .. -DgRPC_INSTALL=ON \
		-DgRPC_BUILD_TESTS=OFF  \
		-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_CROSS_LINUX_RK3568/grpc/ \
		-DCMAKE_TOOLCHAIN_FILE=/opt/rk3568/aarch64-linux-gcc-v12.3/share/buildroot/toolchainfile.cmake \
		-D_gRPC_CPP_PLUGIN=$INSTALL_PREFIX_LINUX/grpc/bin/grpc_cpp_plugin \
		-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=$INSTALL_PREFIX_LINUX/grpc/bin/protoc

make -j8 && make install

# h3_r258
cd $PACKAGE_COMPILE_DIR/grpc && git apply -p1 --ignore-space-change --whitespace=nowarn $GIT_PATCH_DIR/0001-h3_r258.patch
cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_h3_r258 && cd build_h3_r258

cmake .. -DgRPC_INSTALL=ON \
		-DgRPC_BUILD_TESTS=OFF \
		-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_CROSS_LINUX_H3_R258/grpc \
		-DCMAKE_TOOLCHAIN_FILE=$sourcePath/cmakemoudes/linaro_arm.cmake \
		-D_gRPC_CPP_PLUGIN=$INSTALL_PREFIX_LINUX/grpc/bin/grpc_cpp_plugin \
		-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=$INSTALL_PREFIX_LINUX/grpc/bin/protoc

make -j8 && make install
