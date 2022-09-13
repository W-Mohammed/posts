#################

library(dampack)
library(readr)
library(assertthat)

#* @apiTitle Client API hosting sensitive data
#* 
#* @apiDescription This API contains sensitive data, the client does not 
#* want to share this data but does want a consultant to build a health 
#* economic model using it, and wants that consultant to be able to run 
#* the model for various inputs 
#* (while holding certain inputs fixed and leaving them unknown).

#* Log some information about the incoming request
#* @filter logger
function(req) {
  cat(
    "Time: ", as.character(Sys.time()), "\n",
    "HTTP verb: ", req$REQUEST_METHOD, "\n",
    "Endpoint: ", req$PATH_INFO, "\n",
    "Request issuer: ", req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n"
  )
  plumber::forward()
}

#* Check user's credentials in the incoming request
#* @filter security
function(req, res, API_key = "R-HTA-220908") {
  ## Forward requests coming to swagger endpoints:
  if (grepl("docs", tolower(req$PATH_INFO)) |
    grepl("openapi", tolower(req$PATH_INFO))) {
    return(plumber::forward())
  }

  ## Check requests coming to other endpoints:
  ### Grab the key passed in the HEADERS list:
  key <- NULL
  if (!is.null(req$HEADERS["key"])) {
    key <- req$HEADERS["key"]
  }
  ### Check the key passed through with the request object, if any:
  if (is.null(key) | is.na(key)) {
    #### Unauthorised users:
    res$status <- 401 # Unauthorised
    #### Log outcome:
    cat(
      "Authorisation status: 401. API key missing! \n"
    )
    return(list(error = "Authentication required. Please add your API key to the HEADER object using the 'key' value and/or contact API administrator."))
  } else {
    #### Correct credentials:
    if (key == API_key) {
      #### Log outcome:
      cat(
        "Authorisation status: authorised - API key accepted! \n"
      )
      plumber::forward()
    } else {
      #### Incorrect credentials:
      res$status <- 403 # Forbidden
      #### Log outcome:
      cat(
        "Authorisation status: 403. API key incorrect! \n"
      )
      return(list(error = "Authentication failed. Please make sure you have authorisation to access the API and/or contact API administrator."))
    }
  }
}

#* Run the DARTH model
#* @serializer csv
#* @param path_to_psa_inputs is the path of the csv
#* @param model_functions gives the github repo to source the model code
#* @param param_updates gives the parameter updates to be run
#* @post /runDARTHmodel
function(path_to_psa_inputs = "parameter_distributions.csv",
         model_functions = paste0("https://raw.githubusercontent.com/",
                                  "BresMed/plumberHE/main/R/darth_funcs.R"),
         param_updates = data.frame(
           parameter = c("p_HS1", "p_S1H"),
           distribution = c("beta", "beta"),
           v1 = c(25, 50),
           v2 = c(150, 70)
         )) {
  
  
  # source the model functions from the shared GitHub repo...
  source(model_functions)
  
  # read in the csv containing parameter inputs
  psa_inputs <- as.data.frame(readr::read_csv(path_to_psa_inputs))
  
  # for each row of the data-frame containing the variables to be changed...
  for(n in 1:nrow(param_updates)){
  
  # update parameters from API input
  psa_inputs <- overwrite_parameter_value(
                            existing_df = psa_inputs,
                            parameter = param_updates[n,"parameter"], 
                            distribution = param_updates[n,"distribution"],
                            v1 = param_updates[n,"v1"],
                            v2 = param_updates[n,"v2"])
  }
  
  # run the model using the single run-model function.
  results <- run_model(psa_inputs)
  
  # check that the model results being returned are the correct dimensions
  # here we expect a single dataframe with 6 columns and 1000 rows
  assertthat::assert_that(
    all(dim(x = results) == c(1000, 6)),
    class(results) == "data.frame",
    msg = "Dimensions or type of data are incorrect,
  please check the model code is correct or contact an administrator.
  This has been logged"
  )
  
  # check that no data matching the sensitive csv data is included in the output
  # searches through the results data-frame for any of the parameter names,
  # if any exist they will flag a TRUE, therefore we assert that all = F
  assertthat::assert_that(all(psa_inputs[, 1] %in%
        as.character(unlist(x = results,
                            recursive = T)) == F))
  
  return(results)
  
}

#* Scientific paper
#* @preempt security
#* @get /paper
function(){
  return("https://wellcomeopenresearch.org/articles/7-194")
}