ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake \
        gcc \
        g++ \
        git \
        libopenmpi-dev \
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

# Setting environment variables
ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV FC=/usr/bin/mpifort
ENV F77=/usr/bin/mpifort
ENV F90=/usr/bin/mpifort
ENV MPIRUNe=/usr/bin/mpirun

RUN mkdir /home/tpls
COPY build_tpls.py /home/tpls
RUN ls /home/tpls
WORKDIR /home/tpls
RUN python build_tpls.py --wdir $PWD --with all --poolsize 1
