# Dockerfile

# Get the docker image provided by plumber developers:
FROM rstudio/plumber
# Install the R package `pacman`:
RUN R install.packages("pacman")
# Use pacman to install other required packages:
RUN R pacman::p_load("dampack", "readr", "assertthat")
# Create a working directory in the container:
WORKDIR /api
# Copy API files to the created working directory in the container:
COPY ./deploying-plumber-powered-APIs-with-docker/API_files/ /api
# Specify the commands to run once the container runs: 
CMD ["/api/plumber.R"]