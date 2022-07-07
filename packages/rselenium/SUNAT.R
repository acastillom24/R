# Carga de bibliotecas
library(RSelenium)
library(XML)

# Carga de funciones
source(file = "rselenium/functions_SUNAT.R")

# Configuración del driver
driver <- 
  rsDriver(
    browser = "firefox",
    geckover = "0.31.0",
    verbose = FALSE,
    port = 4568L)

# Establecer el cliente
remDr <- 
  driver$client

# Maximizar la ventana del cliente
remDr$maxWindowSize()

# Navegar a la dirección de logueo de la SUNAT
url <- 
  "https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp"

numRuc <- 
  c("20418896915", "20100154308")

dfTrabajadores <- 
  data.frame()

dfRepLegales <- 
  data.frame()

for(i in 1:length(numRuc)){
  result <- consultaRUC(remDr, url, numRuc[i])
  
  dfTrabajadores <- 
    bind_rows(dfTrabajadores, result$NumeroTrabajadores)
    
  dfRepLegales <- 
    bind_rows(dfRepLegales, result$RepresentantesLegales)
}

columName <- 
  c("Periodo", 
    "NumTrabajadores", 
    "NumPensionistas", 
    "NumPrestadoresServicio")

columName <- 
  c("Documento",
    "NumDocum",
    "Nombre",
    "Cargo",
    "FechaDesde")

colnames(dfTrabajadores) <- 
  columName

remDr$closeWindow()
system("taskkill /im java.exe /f")

