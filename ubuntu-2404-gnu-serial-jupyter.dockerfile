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
        libgtest-dev \
        make \
        software-properties-common \
        python3-dev \
        python3-jinja2 \
        python3-numpy \
        pip \
        python-is-python3 \
        graphviz \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

ENV CC=/usr/bin/gcc-11
ENV CXX=/usr/bin/g++-11

RUN pip3 install papermill ipykernel --break-system-packages
RUN pip3 install matplotlib h5py ipywidgets scipy --break-system-packages
# break-system-packages needed, see:
# https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana

RUN mkdir /home/tpls
COPY build_tpls.py /home/tpls
RUN ls /home/tpls
WORKDIR /home/tpls
RUN python build_tpls.py --wdir $PWD --with hdf5 nlopt boost sundials eigen nanoflann stanmath
