FROM rocker/r-ver:4.3.1

# install system dependencies for R packages
RUN apt-get update && apt-get install --no-install-recommends -y \
      libxt6=1:1.2.* \
      pandoc=2.9.2.* \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /report_runner

COPY ./install_dependencies.R install_dependencies.R
RUN Rscript install_dependencies.R


COPY ./template/ template/
COPY ./create_report.R create_report.R

CMD ["Rscript", "create_report.R"]
