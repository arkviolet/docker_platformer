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
