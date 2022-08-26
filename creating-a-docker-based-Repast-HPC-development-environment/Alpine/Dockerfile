# Dockerfile

# Use Alpine as a base-image (layer):
FROM alpine:3.16.2

# Declare image metadata:
LABEL org.opencontainers.image.title="Repast for High Performance Computing (Repast HPC) 2.3.1 docker image"
LABEL org.opencontainers.image.authors="Author(s) name <email address(es)>"
LABEL org.opencontainers.image.source="https://github.com/W-Mohammed/posts/tree/main/creating-a-docker-based-Repast-HPC-development-environment\Alpine"
LABEL org.opencontainers.image.base.name="https://hub.docker.com/layers/ubuntu/library/ubuntu/22.10/images/sha256-75d11da998393ed4a786917130c205967123f7ca8cddce2889fd9e3a0a69fcdd?context=explore"
LABEL org.opencontainers.image.description="This image provides a Repast HPC development environment.\
    The authors of this image adapted it from https://github.com/eze1981/repast-hpc/blob/master/Dockerfile "

# change to root user:
USER root

# Dependencies:
## Install packages:
RUN apk add --no-cache --update \
    bash \
    openssl \
    ca-certificates \
    wget

## Install C++, g++ (compiler) and make utility:
RUN apk add --no-cache gcc \
    make \
    g++ \
    zlib-dev \
    git

# Repast:
# Download, build, and install Repast HPC:
RUN mkdir /tmp/repast-hpc-src
WORKDIR /tmp/repast-hpc-src
RUN \
    ## add the ca-certificates to wget:
    # RUN apk add --no-cache wget == RUN apk update && apk add wget
    # apk add ca-certificates  && \
    # update-ca-certificates && \
    wget github.com/Repast/repast.hpc/releases/download/v2.3.1/repast_hpc-2.3.1.tgz && \
    tar -xvzf repast_hpc-2.3.1.tgz

WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL

# Copy the shell file from GitHb:
COPY install_alpine.sh .

# Add MPICH bin to the PATH:
ENV PATH="/root/sfw/MPICH/bin:${PATH}"

# Install curl:
RUN ./install.sh curl
# Install mpich:
RUN ./install.sh mpich 
# Install NetCDF:
RUN ./install.sh netcdf
# Install Boost:
RUN ./install.sh boost
# Install Repast HPC:
RUN ./install.sh rhpc

# Clean up:
WORKDIR /
RUN rm -rf /tmp/*

# Copy rhpc example files to an examples folder in a project directory:
WORKDIR /project
RUN cp -v -T -r /root/sfw/repast_hpc-2.3.1/bin /project/examples

# Declare start-up command:
CMD ["/bin/sh"]