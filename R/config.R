# Global internal config defaults
.getResultsDir <- function() {
  dir <- file.path(getwd(), "runs")
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  return(dir)
}

.getCacheDir <- function() {
  dir <- file.path(getwd(), "data_cache")
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  return(dir)
}
