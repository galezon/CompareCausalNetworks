library(processx)

runPythonCDAlgo <- function(
    data_path,
    exp_name,
    setOptions = list(),
    exp_details = "NONE",
    run_id = NULL,
    results_dir = "./runs",
    bash_script = system.file("python", "runCD.sh", package = "CompareCausalNetworks")
) {
  
  ensure_file(data_path)
  ensure_dir(results_dir)
  exp_dir <- results_dir
  write_metadata(exp_dir, exp_name, exp_details)
  
  if (is.null(run_id)) {
    run_id <- get_run_id(exp_dir, exp_name)
  } else {
    run_id <- as.integer(run_id)
  }
  
  out_filename <- create_output_filename(exp_name, exp_details, run_id)
  out_path <- file.path(exp_dir, out_filename)
  
  if (bash_script == "") {
    stop("Could not find bash wrapper via system.file(). Is the CompareCausalNetworks package available?")
  }
  ensure_file(bash_script)
  
  # Default options
  optionsList <- list(
    "input_csv"   = data_path,
    "output_csv"  = out_path,
    "exp_name"    = exp_name,
    "exp_details" = exp_details,
    "run_id"      = as.character(run_id),
    "times_2"     = FALSE,
    "times_3"     = FALSE
  )
  optionsList <- adjustOptions(availableOptions = optionsList, optionsToSet = setOptions)
  
  # Build arguments vector for processx
  args <- optionsListToArgs(optionsList)

  message("Running: bash ", paste(shQuote(args), collapse = " "))
  
  # Execute the bash wrapper
  res <- processx::run(
    "bash",
    args = c(bash_script, args),
    echo = TRUE,
    error_on_status = TRUE
  )

  invisible(res)
}
