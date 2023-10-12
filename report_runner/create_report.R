#!/usr/local/bin Rscript
library(logger)
log_threshold(DEBUG)

portfolio_id <- Sys.getenv("PORTFOLIO")
if (!nzchar(portfolio_id)) {
  log_error("PORTFOLIO environment variable not set")
  quit(status = 1)
}
log_info("Creating report for portfolio {portfolio_id}")

portfolio_filename <- paste0(portfolio_id, ".json")
portfolio_path <- file.path("/mnt", "processed_portfolios", portfolio_filename)
if (!file.exists(portfolio_path)) {
  log_error("Portfolio file {portfolio_path} does not exist")
  quit(status = 1)
}

log_debug("Reading portfolio data from {portfolio_path}")
portfolio_contents <- jsonlite::read_json(
  path = portfolio_path,
  simplifyVector = TRUE
)

log_debug("Calculating portfolio statistics")
portfolio_count <- nrow(portfolio_contents)
portfolio_head <- head(portfolio_contents)

creation_path <- file.path("template", portfolio_id)
dir.create(
  path = creation_path,
  showWarnings = TRUE,
  recursive = TRUE
)
creation_path_norm <- normalizePath(creation_path)

log_debug("Creating report at {creation_path_norm}")
bookdown::render_book(
  input = "/report_runner/template",
  output_dir = creation_path_norm,
  output_file = "index.html",
  encoding = "UTF-8",
  clean = FALSE,
  quiet = TRUE,
  params = list(
    portfolio_id = portfolio_id,
    portfolio_count = portfolio_count,
    portfolio_head = portfolio_head
  )
)

output_path <- file.path("/mnt", "reports", portfolio_id)
dir.create(
  path = output_path,
  showWarnings = TRUE,
  recursive = TRUE
)
output_path_norm <- normalizePath(output_path)

log_debug("Copying report to {output_path}")
file.copy(
  from = creation_path_norm,
  to = dirname(output_path_norm),
  recursive = TRUE,
  overwrite = TRUE
)
