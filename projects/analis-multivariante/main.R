# Sitito de trabajo
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Funciones
unirFilas <- function(data, star = 1:4, end = 5:8, names = NULL) {
  dataA = data[,star]
  dataB = data[,end]
  
  if(is.null(names)){
    names = names(dataA)
  }
  
  names(dataA) = names
  names(dataB) = names
  
  ndata = rbind(dataA, dataB)
  
  if(!is.data.frame(data)){
    data = as.data.frame(data)
  }
  
  return(ndata)
}

# Captura de datos por teclado
familias <- read.table(file = "clipboard", header = T)

# Data Alcornoques: Depósitos de corcho (centigramos) de 28 alcornoques en las cuatro direcciones cardinales.
alcornoques <- unirFilas(data = alcornoques)

# Respaldamos los datos
write.csv(x = familias, file = "datos/familias.csv", row.names = F)
