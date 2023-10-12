dependencies <- c(
  "bookdown",
  "jsonlite",
  "logger",
  "rmarkdown"
)

install.packages(
  pkgs = dependencies,
  repos = "https://packagemanager.posit.co/cran/__linux__/jammy/2023-08-31",
  dependencies = c("Depends", "Imports", "LinkingTo")
)
