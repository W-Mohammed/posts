# Dockerfile

# Use Alpine as a base-image (layer):
FROM alpine:3.16.2
# Declare maintainer's name:
LABEL "developer"="Wael Mohammed <mrwaelmohammed@gmail.com>"
LABEL "adapted from"="https://github.com/eze1981/repast-hpc/blob/master/Dockerfile"
# change to root user:
# USER root
# Dependencies:
# Install packages:
RUN apk add --no-cache --update \
    ca-certificates \
    openssl \
    curl
# Install C++, g++ (compiler) and make utility:
RUN apk update && apk add g++ make
# Repast:
# Download, build, and install Repast HPC
RUN mkdir /tmp/repast-hpc-src
WORKDIR /tmp/repast-hpc-src
RUN wget https://github.com/Repast/repast.hpc/releases/download/v2.3.1/repast_hpc-2.3.1.tgz \
    && tar -xvzf repast_hpc-2.3.1.tgz

# Install curl:
# WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL
# RUN ./install.sh curl

# Install mpich:
WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL
RUN sh ./install.sh mpich

# Install NetCDF:
WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL
RUN sh ./install.sh netcdf

# Install Boost:
WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL
RUN sh ./install.sh boost

# Install Repast HPC:
WORKDIR /tmp/repast-hpc-src/repast_hpc-2.3.1/MANUAL_INSTALL
RUN sh ./install.sh rhpc

# Clean up
WORKDIR /
RUN rm -rf /tmp/*

# Browse to project directory
WORKDIR /project

# Move examples into /project directory
RUN mv /root/sfw/repast_hpc-2.3.0/bin/ /project/examples/

# Declare start-up command:
CMD ["/bin/sh"]
