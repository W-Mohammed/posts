# Dockerfile

# Use Alpine as a base-image (layer):
FROM alpine:3.16.2
# Declare maintainer's name:
LABEL "developer"="Wael Mohammed <mrwaelmohammed@gmail.com>"
LABEL "adapted from"="https://github.com/NLKNguyen/alpine-mpich/blob/master/base/Dockerfile"
# change to root user:
USER root
# Dependencies:
# Install mpich: [adapted from https://github.com/NLKNguyen/alpine-mpich/blob/master/base/Dockerfile]
ARG REQUIRE="sudo build-base"
RUN apk update \
    && apk upgrade \
    && apk add --no-cache ${REQUIRE}
RUN apk update \
    && apk add ca-certificates \
    && update-ca-certificates \
    && apk add openssl

#### INSTALL MPICH ####
# Source is available at http://www.mpich.org/static/downloads/

# Build Options:
# See installation guide of target MPICH version
# Ex: http://www.mpich.org/static/downloads/3.2/mpich-3.2-installguide.pdf
# These options are passed to the steps below
ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-fortran"
ARG MPICH_MAKE_OPTIONS

# Download, build, and install MPICH
RUN mkdir /tmp/mpich-src
WORKDIR /tmp/mpich-src
RUN wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xfz mpich-${MPICH_VERSION}.tar.gz  \
    && cd mpich-${MPICH_VERSION}  \
    && ./configure ${MPICH_CONFIGURE_OPTIONS}  \
    && make ${MPICH_MAKE_OPTIONS} && make install \
    && rm -rf /tmp/mpich-src

#### TEST MPICH INSTALLATION ####
RUN mkdir /tmp/mpich-test
WORKDIR /tmp/mpich-test
COPY test.sh .
RUN sh test.sh
RUN rm -rf /tmp/test.sh

#### CLEAN UP ####
WORKDIR /
RUN rm -rf /tmp/*

#### ADD DEFAULT USER ####
ARG USER=mpi
ENV USER ${USER}
RUN adduser -D ${USER} \
    && echo "${USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV USER_HOME /home/${USER}
RUN chown -R ${USER}:${USER} ${USER_HOME}

#### CREATE WORKING DIRECTORY FOR USER ####
ARG WORKDIR=/project
ENV WORKDIR ${WORKDIR}
RUN mkdir ${WORKDIR}
RUN chown -R ${USER}:${USER} ${WORKDIR}

WORKDIR ${WORKDIR}
USER ${USER}

# Declare startup command:
CMD ["/bin/ash"]