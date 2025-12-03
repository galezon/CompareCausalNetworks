.getPackageRoot <- function() {
  # Use the location of this script as anchor
  # Works if sourced or in a package R file
  this_file <- normalizePath(sys.frame(1)$ofile %||% "inst") # fallback for interactive session
  dir <- dirname(this_file)
  
  # Traverse up until you find the benchmark folder
  # assuming CompareCausalNetworks is directly inside benchmark
  root_dir <- normalizePath(file.path(dir, ".."))
  return(root_dir)
}

.getResultsDir <- function() {
  dir <- file.path(.getPackageRoot(), "runs")
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  return(normalizePath(dir))
}

.getCacheDir <- function() {
  dir <- file.path(.getPackageRoot(), "data_cache")
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  return(normalizePath(dir))
}
