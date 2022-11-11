# Carga de bibliotecas
library(RSelenium)
library(XML)

# Carga de funciones
source(file = "script/SUNAT-funciones.R")

# Versión del driver
binman::list_versions(appname = "chromedriver")

# Cerrar los puertos
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

# Configuración del driver
driver <- 
  rsDriver(
    browser = "chrome",
    chromever = "105.0.5195.52",
    verbose = F,
    port = 4568L)

# Establecer el cliente
remDr <- 
  driver$client

# Abrir cliente del driver
remDr$open()

# Maximizar la ventana del cliente
remDr$maxWindowSize()

# Navegar a la dirección de login de la SUNAT
url <- 
  "https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp"

remDr$navigate(url)

xpath_btnRuc <- 
  "//button[@id='btnPorRuc']"

xpath_btnDocum <- 
  "//button[@id='btnPorDocumento']"

xpath_btnRazonSoc <- 
  "//button[@id='btnPorRazonSocial']"

xpath_txtRuc <- 
  "//input[@id='txtRuc']"

xpath_btnAceptar <- 
  "//button[@id='btnAceptar']"


remDr$findElement(using = "xpath", value = xpath_btnRuc)$clickElement()

remDr$findElement(using = "xpath", value = xpath_txtRuc)$sendKeysToElement(list("20202380621"))

remDr$findElement(using = "xpath", value = xpath_btnAceptar)$clickElement()

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

