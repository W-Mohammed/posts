# Dockerfile

# Declare the base layer:
FROM r-base:4.2.1
# Set the container's "/src" folder as its working directory:
WORKDIR /src
# Copy files from host's current directory to container's working directory "/src" denoted with a dot ".":
COPY ./getting-started-with-docker/r_hello-world/ .
# Set the command the container calls when we run it:
CMD R hello.R