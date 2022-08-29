# Dockerfile

# This dockerfile contains the instructions required to build a Repast HPC image powered by Ubuntu Linux. 

# Declare the version of ubuntu's base image:
ARG UBUNTU_VERSION="22.10"

# Start from an ubuntu official image:
FROM ubuntu:${UBUNTU_VERSION}

# Declare image metadata:
LABEL org.opencontainers.image.title="Repast for High Performance Computing (Repast HPC) 2.3.1 docker image"
LABEL org.opencontainers.image.authors="Author(s) name <email address(es)>"
LABEL org.opencontainers.image.source="https://github.com/W-Mohammed/posts/tree/main/creating-a-docker-based-Repast-HPC-development-environment/Ubuntu"
LABEL org.opencontainers.image.base.name="https://hub.docker.com/layers/ubuntu/library/ubuntu/22.10/images/sha256-75d11da998393ed4a786917130c205967123f7ca8cddce2889fd9e3a0a69fcdd?context=explore"
LABEL org.opencontainers.image.description="This image provides a Repast HPC development environment.\
    The authors of this image adapted it from https://github.com/eze1981/repast-hpc/blob/master/Dockerfile"

# Install system dependencies:
RUN apt update -y && \
    apt upgrade -y git \
        build-essential \
        zlib1g-dev \
        libgtest-dev && \
    apt-get install wget

# Set a temporary working directory:
WORKDIR /temp/repast-hpc-src

# Declare the version of Repast HPC (rhpc) to be installed:
ARG RHPC_VERSION="2.3.1"

# Download Repast HPC (rhpc) compressed file:
RUN wget https://github.com/Repast/repast.hpc/releases/download/v${RHPC_VERSION}/repast_hpc-${RHPC_VERSION}.tgz && \
    tar -xvzf repast_hpc-${RHPC_VERSION}.tgz 

# Move working directory to installation folder:
WORKDIR /temp/repast-hpc-src/repast_hpc-${RHPC_VERSION}/MANUAL_INSTALL

# Add MPICH bin to the PATH:
ENV PATH="/root/sfw/MPICH/bin:${PATH}"

# Install repast hpc dependencies:
RUN ./install.sh curl && \
    ./install.sh mpich && \
    ./install.sh netcdf && \
    ./install.sh boost

# Install repast hpc:
RUN ./install.sh rhpc

# Remove unneeded files:
RUN apt remove -y git build-essential && \
    apt autoremove -y

# Pass the libraries directories to ld
RUN ldconfig /root/sfw/CURL/lib/ \
    /root/sfw/MPICH/lib/ \
    /root/sfw/NetCDF/lib/ \
    /root/sfw/NetCDF-cxx/lib/ \
    /root/sfw/repast_hpc-2.3.1/lib/ \
    /root/sfw/Boost/Boost_1.61/lib/

# Remove unneeded files:
WORKDIR /
RUN rm -rf temp

# Copy rhpc example files to an examples folder in a project directory:
WORKDIR /project
RUN cp -v -T -r /root/sfw/repast_hpc-${RHPC_VERSION}/bin /project/examples

# Declare start-up command:
CMD ["/bin/sh"]

# To share this dockerfile:
## Create a GitHub personal access token (PAT) for use in the command line
## Save it using the command `export GH_CR_TOKEN=KEY` on Linux or
## $env:GH_CR_TOKEN="KEY" on Windows
## $env:GH_CR_TOKEN prints the value of the environment variable GH_CR_TOKEN
## Sign in to the Container registry service at ghcr.io `docker login ghcr.io -u W-Mohammed -p $env:GH_CR_TOKEN`
## $env:GH_CR_TOKEN | docker login ghcr.io -u W-Mohammed --password-stdin
## The above command only worked from PowerShell
## Tag an image with `docker image tag third_ubuntu:latest ghcr.io/w-mohammed/repast-hpc:v1`
## Push the image with `docker image push ghcr.io/w-mohammed/repast-hpc:v1`
## Push the image with `docker image push ghcr.io/w-mohammed/repast-hpc:v2`
## Push the image with `docker image push ghcr.io/w-mohammed/repast-hpc:v3`
