#!/usr/bin/env bash

set -ex

sourcePath=/home/developer/workspace

PACKAGE_COMPILE_DIR=$sourcePath/packages
INSTALL_PREFIX_CROSS_LINUX=$sourcePath/software/cross

cd $sourcePath

mkdir -vp $PACKAGE_COMPILE_DIR
mkdir -vp $INSTALL_PREFIX_CROSS_LINUX

##########################################################################################
# glog

# gflags

# gtest

# protobuf

# grpc
# grpc
cd $PACKAGE_COMPILE_DIR

git clone --recurse-submodules -b v1.50.1 --depth 1 --shallow-submodules https://github.com/grpc/grpc

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build && cd build

cmake .. -DgRPC_INSTALL=ON \
         -DgRPC_BUILD_TESTS=OFF \
         -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_LINUX/grpc

make -j8 && make install

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_rk3568 && cd build_rk3568

cmake .. -DgRPC_INSTALL=ON \
		-DgRPC_BUILD_TESTS=OFF  \
		-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_CROSS_LINUX/grpc/rk3568 \
		-DCMAKE_TOOLCHAIN_FILE=/opt/workspace/Rockchip/rk3568/aarch64-linux-gcc-v12.3/share/buildroot/toolchainfile.cmake \
		-D_gRPC_CPP_PLUGIN=$INSTALL_PREFIX_LINUX/grpc/bin/grpc_cpp_plugin \
		-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=$INSTALL_PREFIX_LINUX/grpc/bin/protoc

make -j8 && make install

cd $PACKAGE_COMPILE_DIR/grpc && mkdir build_h3_r258 && cd build_h3_r258

cmake .. -DgRPC_INSTALL=ON \
		-DgRPC_BUILD_TESTS=OFF \
		-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX_CROSS_LINUX/grpc/h3_r258 \
		-DCMAKE_TOOLCHAIN_FILE=$sourcePath/cmakemoudes/h3_r258.cmake \
		-D_gRPC_CPP_PLUGIN=$INSTALL_PREFIX_LINUX/grpc/bin/grpc_cpp_plugin \
		-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=$INSTALL_PREFIX_LINUX/grpc/bin/protoc

cd $PACKAGE_COMPILE_DIR/grpc && git apply -p1 --ignore-space-change --whitespace=nowarn GIT_PATCH_DIR/grpc_h3_r258.patch

cd $PACKAGE_COMPILE_DIR/grpc/cd build_h3_r258

make -j8 && make install