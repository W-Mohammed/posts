# Dockerfile

# Get the docker image provided by plumber developers:
FROM rstudio/plumber
# Install the R package `pacman`:
RUN R -e "install.packages('pacman')"
# Use pacman to install other required packages:
RUN R -e "pacman::p_load('readr')"
# Create a working directory in the container:
WORKDIR /api
# Copy API files to the created working directory in the container:
COPY ./hosting-model-data-remotely-with-docker/API_files/ /api
# Specify the commands to run once the container runs: 
CMD ["/api/sicksickerPack-API.R"]