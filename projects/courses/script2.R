datos <- read.csv(file.choose(), sep =",")
datos <- read.csv(file.choose(), sep =";")

ll_exponential <- 
  function(lambda, x){
    N <- length(x)
    -1 * N * log(lambda) + lambda * sum(x)
  }

optim(
  par = 2, 
  fn = ll_exponential, 
  method = "L-BFGS-B", 
  lower = 0.00001, 
  x = datos$tiempo)

ll_weibull <- 
  function(){
    
  }