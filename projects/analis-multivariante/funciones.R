# Medias, covarianzas y correlaciones

am.medias <- function(X){
  if(!is.matrix(X)){
    X = as.matrix(X)
  }
  
  n = dim(X)[1]
  unos = matrix(data = rep(x = 1, n), ncol = 1)
  
  result = t((1/n)*(t(unos) %*% X))
  colnames(result) = "Medias"
  return(result)
}

am.centrados <- function(X){
  n = dim(X)[1]
  I = diag(n)
  J = matrix(data = rep(x = 1, (2*n)), nrow = n, ncol = n)
  H = I - (1/n)*J
  result = H %*% X
  return(result)
}

am.covarianzas <- function(X){
  centrados = am.centrados(X)
  n = dim(X)[1]
  S = (1/n) * (t(centrados) %*% centrados)
  return(S)
}

am.correlaciones <- function(X){
  S = am.covarianzas(X)
  D = diag(sqrt(S))
  D = diag(x = D, nrow = length(D), ncol = length(D))
  R = solve(D) %*% S %*% solve(D)
  return(R)
}


