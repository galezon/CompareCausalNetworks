library(reticulate)

# TODO: clean up hard-coded virtualenv path
use_condaenv("expertloop")

runPythonCDAlgo <- function(X, parentsOf, alpha, variableSelMat, setOptions, directed, verbose,
                   result, ...){
  # only parameters needed to be considered are X and setOptions

  dots <- list(...)
  if(length(dots) > 0){
    warning("options provided via '...' not taken")
  }

  source_python(
    system.file("python", "python_cd_algo.py", package = "CompareCausalNetworks")
  )
  
 # additional options for PC
 optionsList <- list(
   times_2=FALSE
                     )

 # adjust according to setOptions if necessary
 optionsList <- adjustOptions(availableOptions = optionsList,
                               optionsToSet = setOptions)

  pcmat <- cd_algorithm(
    X=X,
    times_2=optionsList$times_2,
    times_3=if (!is.null(optionsList$times_3)) optionsList$times_3 else FALSE
  )
  
  if(directed){
    warning("Removing undirected edges from estimated adjacency matrix.")
    pcmat <- pcmat * (t(pcmat)==0)
  }
  
  result <- vector("list", length = length(parentsOf))
  
  for (k in 1:length(parentsOf)){
    result[[k]] <- which(as.logical(pcmat[, parentsOf[k]]))
    attr(result[[k]],"parentsOf") <- parentsOf[k]
  }
  
  if(length(parentsOf) < ncol(X)){
    pcmat <- pcmat[,parentsOf]
  }
  
  list(resList = result, resMat = pcmat)
}