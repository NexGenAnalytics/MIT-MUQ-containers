ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake \
        gcc \
        g++ \
        git \
        libgtest-dev \
        make \
        software-properties-common \
        python3-dev \
        pip \
        python-is-python3 \
        graphviz \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

RUN mkdir /home/tpls
COPY build_tpls.py /home/tpls
RUN ls /home/tpls
WORKDIR /home/tpls
RUN python build_tpls.py --wdir $PWD --with hdf5 nlopt boost sundials eigen nanoflann stanmath --poolsize 1
