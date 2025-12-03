library(digest)

# function to determine number of settings to draw
drawE <- function(x){
  z <- floor(x)
  if(runif(1) < x-z) z <- z+1
  z <- max(1,z)
  return(z)
}

ensure_dir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
}

ensure_file <- function(path) {
  if (!file.exists(path)) {
    stop(sprintf("File does not exist: %s", path))
  }
}

create_output_filename <- function(exp_name, run_id) {
  sprintf("%s_run_%03d.csv", exp_name, run_id)
}

write_metadata <- function(results_dir, exp_name, exp_details) {
  meta_file <- file.path(results_dir, "metadata.txt")
  if (!file.exists(meta_file)) {
    meta <- paste0(
      "Experiment: ", exp_name, "\n",
      "Details: ", exp_details, "\n",
      "Created: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n"
    )
    writeLines(meta, meta_file)
  }
}

get_run_id <- function(exp_dir, exp_name) {
  existing <- list.files(
    exp_dir,
    pattern = paste0("^", exp_name, "_.*run_\\d+\\.csv$")
  )
  run_id <- length(existing) + 1L
  
  return(run_id)
}

# Converts an options list into CLI arguments for processx::run
optionsListToArgs <- function(optionsList) {
  if (!is.list(optionsList)) {
    stop("optionsList must be a named list")
  }
  
  args <- unlist(lapply(names(optionsList), function(k) {
    v <- optionsList[[k]]
    
    # Skip NULLs
    if (is.null(v)) return(NULL)
    
    if (is.logical(v) && length(v) == 1) {
      c(paste0("--", k), ifelse(v, "true", "false"))
    }
    else if (length(v) == 1) {
      c(paste0("--", k), as.character(v))
    }
    else {
      NULL
    }
  }), use.names = FALSE)
  
  return(args)
}

get_data_path <- function(X_or_data_path) {
  if (is.character(X_or_data_path) && file.exists(X_or_data_path)) {
    data_path <- X_or_data_path
  } else if (is.matrix(X_or_data_path) || is.data.frame(X_or_data_path)) {
    hash <- digest::digest(X_or_data_path, algo = "md5")
    data_path <- file.path(CACHE_DIR, paste0("data_", hash, ".csv"))
    if (!file.exists(data_path)) {
      write.csv(X_or_data_path, data_path, row.names = FALSE)
    }
  } else {
    stop("X must be a data.frame/matrix or an existing CSV file path")
  }
}