FROM rocker/r-ver:4.3.1

WORKDIR /portfolio_parser

COPY ./install_dependencies.R install_dependencies.R
RUN Rscript install_dependencies.R
 
COPY ./process_portfolios.R process_portfolios.R

CMD ["Rscript", "process_portfolios.R"]
