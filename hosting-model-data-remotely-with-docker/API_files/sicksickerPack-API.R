#################

#* @apiTitle Client API hosting sensitive model data
#*
#* @apiDescription This API contains sensitive data, the client does not
#* want to share this data but does want to make the model utilising this data
#* accessible.

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
function(req, res, API_key = "R-HTA_2023") {
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
    return(
        list(
            error = paste(
                "Authentication required. Please add",
                "your API key to the HEADER object using the 'key'",
                "value and/or contact API administrator."
            )
        )
    )
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
      return(
          list(
              error = paste(
                  "Authentication failed. Please make sure you have",
                  "authorisation to access the API and/or contact API",
                  "administrator."
              )
          )
      )
    }
  }
}

#* Get model parameters
#* @serializer csv
#* @get /modelRunParams
function() {
  model_data <- data.frame(
    age_init_ = 25,
    age_max_  = 55,
    discount_rate_ = 0.035,
    p_HD    = 0.005,
    p_HS1   = 0.15,
    p_S1H   = 0.5,
    p_S1S2  = 0.105,
    hr_S1   = 3,
    hr_S2   = 10,
    c_H     = 2000,
    c_S1    = 4000,
    c_S2    = 15000,
    c_Trt   = 12000,
    c_D     = 0,
    u_H     = 1,
    u_S1    = 0.75,
    u_S2    = 0.5,
    u_D     = 0,
    u_Trt   = 0.95
  )

  return(model_data)
}

#* Get probabilistic sensitivity analysis (PSA) parameters
#* @serializer unboxedJSON
#* @get /psaRunParams
function() {
  psa_params <- list(
    "psa_params_names" = c(
      "p_HS1", "p_S1H", "p_S1S2", "p_HD", "hr_S1", "hr_S2", "c_H", "c_S1", 
      "c_S2", "c_D", "c_Trt", "u_H", "u_S1", "u_S2", "u_D", "u_Trt"
    ),
    "psa_params_dists" = c(
      "p_HS1" = "beta", "p_S1H" = "beta", "p_S1S2" = "beta", "p_HD" = "beta",
      "hr_S1" = "lnorm", "hr_S2" = "lnorm", "c_H" = "gamma", "c_S1" = "gamma",
      "c_S2" = "gamma", "c_D" = "fixed", "c_Trt" = "fixed", "u_H" = "truncnorm",
      "u_S1" = "truncnorm", "u_S2" = "truncnorm", "u_D" = "fixed",
      "u_Trt" = "truncnorm"
    ),
    "psa_params_dists_args" = list(
      "p_HS1" = list(
        shape1 = 30,
        shape2 = 170
      ),
      "p_S1H" = list(
        shape1 = 60,
        shape2 = 60
      ),
      "p_S1S2" = list(
        shape1 = 84,
        shape2 = 716
      ),
      "p_HD" = list(
        shape1 = 10,
        shape2 = 1990
      ),
      "hr_S1" = list(
        meanlog = log(3),
        sdlog = 0.01
      ),
      "hr_S2" = list(
        meanlog = log(10),
        sdlog = 0.02
      ),
      "c_H" = list(
        shape = 100,
        scale = 20
      ),
      "c_S1" = list(
        shape = 177.8,
        scale = 22.5
      ),
      "c_S2" = list(
        shape = 225,
        scale = 66.7
      ),
      "c_D" = list(0),
      "c_Trt" = list(12000),
      "u_H" = list(
        mean = 1,
        sd = 0.01,
        b = 1
      ),
      "u_S1" = list(
        mean = 0.75,
        sd = 0.02,
        b = 1
      ),
      "u_S2" = list(
        mean = 0.50,
        sd = 0.03,
        b = 1
      ),
      "u_D" = list(0),
      "u_Trt" = list(
        mean = 0.95,
        sd = 0.02,
        b = 1
      )
    )
  )

  return(psa_params)
}

#* Scientific paper
#* @serializer html
#* @preempt security
#* @get /paper
function(req, res) {
  res$status <- 303 # redirect
  res$setHeader("Location", "https://wellcomeopenresearch.org/articles/7-194")
  "<html>
    <head>
      <meta http-equiv=\"Refresh\" content=\"0; url=https://wellcomeopenresearch.org/articles/7-194\" />
    </head>
    <body>
      <p>Please follow <a href=\"https://wellcomeopenresearch.org/articles/7-194\">this link</a>.</p>
    </body>
  </html>"
}

#* Check the API key
#* @preempt security
#* @get /checkAPIkey
function(req, res, API_key = "R-HTA_2023") {
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
    return(
        list(
            error = paste(
                "Authentication required. Please add",
                "your API key to the HEADER object using the 'key'",
                "value and/or contact API administrator."
            )
        )
    )
  } else {
    #### Correct credentials:
    if (key == API_key) {
      #### Log outcome:
      cat(
        "Authorisation status: authorised - API key accepted! \n"
      )
      return(TRUE)
    } else {
      #### Incorrect credentials:
      res$status <- 403 # Forbidden
      #### Log outcome:
      cat(
        "Authorisation status: 403. API key incorrect! \n"
      )
      return(
          list(
              error = paste(
                  "Authentication failed. Please make sure you have",
                  "authorisation to access the API and/or contact API",
                  "administrator."
              )
          )
      )
    }
  }
}