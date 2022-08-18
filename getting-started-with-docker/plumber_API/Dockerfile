# Get the docker image provided by plumber developers:
FROM rstudio/plumber
# Install R packages requireed by the API:
# RUN R -e "install.packages('pacman')"
# RUN R -e "pacman::p_load('', '','ggplot2', 'rmarkdown')"
# Create a working directory in the container:
WORKDIR /api
# Copy API files to the created working directory in the container:
COPY ./getting-started-with-docker/API_files/ /api
# Specify the commands to run once the container runs: 
CMD ["/api/plumber.R"]