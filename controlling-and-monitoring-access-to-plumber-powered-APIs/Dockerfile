# Dockerfile

# Get the docker image provided by plumber developers:
FROM rstudio/plumber
# Install the R package `pacman`:
RUN R -e "install.packages('pacman')"
# Use pacman to install other required packages:
RUN R -e "pacman::p_load('assertthat', 'dampack', 'ggplot2', 'jsonlite', 'readr')"
# Create a working directory in the container:
WORKDIR /api
# Copy API files to the created working directory in the container:
COPY ./RobertASmithBresMed-plumberHE-809f204/darthAPI /api
# Specify the commands to run once the container runs: 
CMD ["./plumber.R"]