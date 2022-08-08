# plumber.R

# Below are the API methods and their corresponding functions, whereas the API title and description are at the end of the file.

#* Welcome user.
#* The API says "Hi".
#* @param userName The user's name
#* @get /echo
function(userName="") {
  list(msg = paste0("Welcome to your first API, '", userName, "'"))
}

#* Draw a scatter plot.
#* This function will generate a scatter plot from 1000 randomly
#* sampled pairs of values.
#* @serializer png
#* @get /plot
function() {
  Random_1 <- rnorm(1000)
  Random_2 <- rnorm(1000)
  plot(Random_1, Random_2)
}

#* Multiply numbers.
#* Return the multiplication of two numbers.
#* @param a The first number
#* @param b The second number
#* @post /multiply
function(a, b) {
  as.numeric(a) * as.numeric(b)
}

#* @apiTitle Getting started with plumber
#* 
#* @apiDescription Welcome to this demo API which was built to introduce
#* first time plumber-powered API developers to the process. The idea behind
#* these few lines are to populate Swagger auto-generated documentation which
#* can be later accessed by the sub-domain (_docs_/) or (\_docs\_/) in case
#* you do not see the underscore before and after the term "docs". 
#* For example (http://127.0.0.1:0000/\_docs\_/).
#*
