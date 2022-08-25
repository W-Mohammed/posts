# Dockerfile

# Construct an image using the original repast
FROM ubuntu:20.04

# Declare maintainer's name:
LABEL "developer"="Wael Mohammed <mrwaelmohammed@gmail.com>"
LABEL "adapted from"="https://github.com/eze1981/repast-hpc/blob/master/Dockerfile"

# Add MPICH bin to the PATH:
ENV PATH="/root/sfw/MPICH/bin:${PATH}"

# Set working directory for following commands:
WORKDIR /temp/repast-hpc-src

# Install requirements and clone Repast.HPC
RUN apt update -y && \
    apt upgrade -y git build-essential zlib1g-dev libgtest-dev && \
    apt-get install wget

RUN wget https://github.com/Repast/repast.hpc/releases/download/v2.3.1/repast_hpc-2.3.1.tgz && \
    tar -xvzf repast_hpc-2.3.1.tgz && \
    cd repast_hpc-2.3.1/MANUAL_INSTALL && \
    # Install repast hpc dependencies:
    ./install.sh curl && \
    ./install.sh mpich && \
    ./install.sh netcdf && \
    ./install.sh boost && \
    # Install repast hpc:
    ./install.sh rhpc && \
    # mkdir /demo/repast.hpc/Debug && \
    # cd /demo/repast.hpc/Debug && \
    # cp ../Makefile.tmplt ./Makefile && \
    # cd /demo/repast.hpc/Debug && \
    # make install && \
    # Compile the demo
    # cd /demo && \
    # cd /demo/src/ && \
    # mkdir /demo/src/build && \
    # make bugdemo && \
    apt remove -y git build-essential && \
    apt autoremove -y && \
    # Pass the libraries directories to ld
    ldconfig /root/sfw/CURL/lib/ \
    /root/sfw/MPICH/lib/ \
    /root/sfw/NetCDF/lib/ \
    /root/sfw/NetCDF-cxx/lib/ \
    /root/sfw/repast_hpc-2.3.1/lib/ \
    /root/sfw/Boost/Boost_1.61/lib/ && \
    cd .. && \
    cd .. && \
    cd .. && \
    rm -rf repast-hpc-src

# Set rhpc download dir as working directory:
WORKDIR /root/sfw/repast_hpc-2.3.1

# Declare start-up command:
CMD ["/bin/sh"]
