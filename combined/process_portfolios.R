#!/usr/local/bin/Rscript
library(logger)
log_threshold(DEBUG)

write_mapping <- function(
  source_file,
  destination_file,
  user_id,
  con = file.path("/mnt", "processed_portfolios", "00-Database.csv")
) {
  if (!file.exists(con)) {
    log_debug("Creating database file")
    writeLines(
      text = "source_file, destination_file, user_id",
      con = con
    )
  }
  log_debug("Writing mapping to database")
  newline <- paste(
    source_file,
    destination_file,
    user_id,
    sep = ", "
  )
  write(
    x = newline,
    file = con,
    append = TRUE
  )
  log_debug("Mapping written to database")
}

portfolio_search_path <- file.path("/mnt", "raw_portfolios")

log_debug("Searching for files")
log_trace("Searching for files in %s", portfolio_search_path)
files_to_process <- list.files(
  path = portfolio_search_path,
  full.names = TRUE,
  include.dirs = FALSE,
  pattern = "*.csv",
  recursive = FALSE
)
log_debug("Found {length(files_to_process)} files")

for (f in files_to_process) {

  log_info("Processing file: {f}")
  contents <- read.csv(
    file = f,
    header = TRUE
  )
  if (nrow(contents) == 0) {
    log_warn("File {f} is empty")
    next
  }
  contents_json <- jsonlite::toJSON(
    x = contents,
    pretty = TRUE
  )
  guid <- uuid::UUIDgenerate()
  output_file <- file.path(
    "/mnt",
    "processed_portfolios",
    paste0(guid, ".json")
  )
  log_debug("writing to file: {output_file}")
  writeLines(
    text = contents_json,
    con = output_file
  )
  write_mapping(
    source_file = f,
    destination_file = output_file,
    user_id = Sys.getenv("USERID")
  )
  log_info("Source file {f} processed to {output_file}")

}

log_debug("No more portfolios found. Exiting")
