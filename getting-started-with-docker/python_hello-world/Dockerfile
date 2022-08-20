# Dockerfile

# Declare the base layer:
FROM python:3.7.13-alpine3.16
# Copy files from host's current directory to container's "/src" folder:
COPY ./getting-started-with-docker/python_hello-world/ /src
# Set the container's "/src" folder as its working directory:
WORKDIR /src
# Set the command the container calls when we run it:
CMD python hello.py