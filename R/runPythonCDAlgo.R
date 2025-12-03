library(processx)

# Ensure bash wrapper under CompareCausalNetworks\inst\bash
BASH_WRAPPER_FILE = "runCDAlgo.sh"  # REPLACE

runPythonCDAlgo <- function(
    data_path,
    exp_name,
    setOptions = list(),
    exp_details = "NONE",
    run_id = NULL,
    results_dir = "./runs"
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
  
  bash_script = system.file("bash", BASH_WRAPPER_FILE, package = "CompareCausalNetworks")
  if (bash_script == "") {
    stop("Could not find bash wrapper via system.file().")
  }
  ensure_file(bash_script)
  
  # Default options
  optionsList <- list(
    # MANDATORY ARGUMENTS
    "input_csv"   = data_path,
    "output_csv"  = out_path,
    "exp_name"    = exp_name,
    "exp_details" = exp_details,
    "run_id"      = as.character(run_id),
    # OPTIONAL ARGUMENTS
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
