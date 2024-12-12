#!/usr/bin/env bash

set -ex

sourcePath=$(cd $(dirname $0) && pwd)

docker-compose -f kviolet.yaml run --rm dev ./docker_platformer/compile_cross_3rd.sh

docker-compose -f kviolet.yaml run --rm dev ./docker_platformer/compile_cross_linux_tools.sh