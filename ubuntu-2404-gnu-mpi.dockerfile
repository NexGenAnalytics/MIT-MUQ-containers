ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake \
	doxygen \
        gcc-11 \
        g++-11 \
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

RUN pip install Jinja2
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

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
