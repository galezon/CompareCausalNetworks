library(processx)

# Ensure bash wrapper under /CompareCausalNetworks/inst/bash
BASH_WRAPPER_FILE = "runCDAlgo.sh"
RESULTS_DIR = .getResultsDir()
CACHE_DIR = .getCacheDir()

runPythonCDAlgo <- function(
    X,
    parentsOf = NULL,  # inelegant
    alpha = 0.1,  # defaults from getParents
    variableSelMat = NULL, # defaults from getParents
    setOptions = list(),
    directed = TRUE,
    verbose = FALSE,
    exp_name,
    exp_details = NULL,
    ...
) {
  # write_metadata(RESULTS_DIR, exp_name, exp_details)
  
  run_id <- get_run_id(RESULTS_DIR, exp_name)
  out_filename <- create_output_filename(exp_name, run_id)
  out_path <- file.path(RESULTS_DIR, out_filename)
  
  data_path = get_data_path(X)
  print(data_path)
  
  # should be under find_bash_script()
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
    "times_2"     = FALSE,  # REMOVE/REPLACE
    "times_3"     = FALSE   # REMOVE/REPLACE
  )
  optionsList <- adjustOptions(availableOptions = optionsList, optionsToSet = setOptions)
  
  # Build arguments vector for processx
  args <- optionsListToArgs(optionsList)

  message("Running: bash ", bash_script, " ", paste(shQuote(args), collapse = " "))
  
  # Execute the bash wrapper
  res <- processx::run(
    "bash",
    args = c(bash_script, args),
    echo = TRUE,
    error_on_status = TRUE
  )

  invisible(res)
  return(read.csv(out_path))
}
