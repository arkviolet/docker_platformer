FROM hub.atomgit.com/amd64/ubuntu:22.04

LABEL maintainer="h18309294659@aliyun.com"

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

ENV HOST_UID=1000
ENV HOST_GID=1000
ENV USER_NAME=developer

COPY etc /etc/

#RUN dpkg --add-architecture arm64
#RUN dpkg --add-architecture armhf

RUN apt-get update && \
    apt-get install -y \
    sudo \
    dos2unix \
    build-essential gcc g++ automake autoconf \
    wget curl vim ack git gitk \
    pulseaudio libpulse-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    unzip libtiff-dev libopenexr-dev \
    libdbus-1-3 libdbus-1-dev \
    libusb-1.0-0 libusb-1.0-0-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tclsh

RUN apt-get install -y \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu 

ENV http_proxy=http://172.29.16.1:10809
ENV https_proxy=http://172.29.16.1:10809

RUN curl https://cmake.org/files/v3.24/cmake-3.24.3-linux-x86_64.sh -O
RUN bash ./cmake-3.24.3-linux-x86_64.sh --skip-license --prefix=/usr
RUN rm ./cmake-3.24.3-linux-x86_64.sh

RUN apt-get install python3-paramiko -y

RUN useradd -s /bin/bash -m ${USER_NAME} -u ${HOST_UID} && echo 'developer    ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER ${USER_NAME}

WORKDIR /home/developer/workspace
