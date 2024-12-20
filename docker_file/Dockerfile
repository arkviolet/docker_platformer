# 交叉编译环境

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
    curl wget \
    git gitk gitg\
    dos2unix \
    libtool autopoint pkgconf automake autoconf texinfo \
    libv4l-dev libffi-dev libmount-dev \
    libpcre3 libpcre3-dev \
    build-essential ninja-build bison flex \
    zlib1g-dev libssl-dev gtk-doc-tools meson \
    libglib2.0-dev \
    gcc g++ \
    vim ack \
    python3 python3-pip

# proxy
ENV http_proxy=http://172.29.16.1:10809
ENV https_proxy=http://172.29.16.1:10809

# cmake
RUN curl https://cmake.org/files/v3.24/cmake-3.24.3-linux-x86_64.sh -O
RUN bash ./cmake-3.24.3-linux-x86_64.sh --skip-license --prefix=/usr && rm ./cmake-3.24.3-linux-x86_64.sh

# python
RUN pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --upgrade meson ninja -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN useradd -s /bin/bash -m ${USER_NAME} -u ${HOST_UID} && echo 'developer    ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER ${USER_NAME}

WORKDIR /home/developer/workspace
