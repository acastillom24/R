# Carga de bibliotecas
library(RSelenium)
library(XML)

# Versiones de los drivers
binman::list_versions(appname = "geckodriver")
binman::list_versions(appname = "chromedriver")

# Cerrar los puertos abiertos
## Opción: 1
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)
## Opción: 2
pid <- driver$server$process$get_pid()
system(paste0("Taskkill /F /T" ," /PID ", pid))

# Configuración del driver
driver <- 
  rsDriver(
    browser = "firefox",
    geckover = "0.31.0",
    verbose = FALSE,
    port = 4567L)

# Establecer el cliente
remDr <- 
  driver$client

# Abrir el cliente
remDr$open()

# Maximizar la ventana del cliente
remDr$maxWindowSize()

# Navegar a la dirección de logueo de la SUNAT
url <- 
  "https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp"
remDr$navigate(url = url)

# Buscar RUC
xpath_ruc <- 
  "//div[@id='divRuc']/input"

xpath_btn_buscar <- 
  "//button[@id='btnAceptar']"

elem_buscar_ruc <- 
  remDr$findElement(
    using = "xpath", 
    value = xpath_ruc)

elem_btn_buscar <- 
  remDr$findElement(
    using = "xpath",
    value = xpath_btn_buscar
  )

numRuc = "20418896915"
elem_buscar_ruc$sendKeysToElement(list(numRuc))
elem_btn_buscar$clickElement()

# Buscar el número de trabajadores
xpath_btn_trabajadores <- 
  "//button[contains(text(), 'Trabajadores')]"

elem_btn_trabajadores <- 
  remDr$findElement(
    using = "xpath",
    value = xpath_btn_trabajadores
  )

elem_btn_trabajadores$clickElement()

# Obtener el número de trabajadores
xpath_tbl_trabajadores <- 
  "//tbody/tr"

elems_tbl_trabajadores <- 
  remDr$findElements(
    using = "xpath",
    value = xpath_tbl_trabajadores
  )

# Ver la estructura html del documento
htmlParse(file = remDr$getPageSource()[[1]])

tblNumTrabajadores <- 
  readHTMLTable(
    doc = tab, 
    which = 1,
    encoding = "UTF-8", 
    stringsAsFactors = F, 
    as.data.frame = T)

columName <- 
  c("Periodo", 
    "NumTrabajadores", 
    "NumPensionistas", 
    "NumPrestadoresServicio")

colnames(tblNumTrabajadores) <- 
  columName

tblNumTrabajadores <- 
  tblNumTrabajadores %>% 
  mutate(
    NumTrabajadores = as.integer(gsub(" ", "", NumTrabajadores)),
    NumPensionistas = as.integer(NumPensionistas),
    NumPrestadoresServicio = as.integer(NumPrestadoresServicio))

# Comando
remDr$goBack() #Anterior
remDr$goForward() #Siguiente
remDr$refresh() #Recargar la página


# Drop Down
elemen_drow_down <- 
  remDr$findElement()

remDr$mouseMoveToLocation(webElement = elemen_drow_down)

# Move to the end of document html
remDr$executeScript("window.scrollTo(0, document.body.scrollHeight);")

# Pausa
Sys.sleep(3)

# Recorrer elementos
lapply(elementos, function(x){
  x$getElementText() %>% unlist()
}) %>% flatten_chr()

# Cerrar la ventana
remDr$closeWindow

# Cerrar el servidor
system("taskkill /im java.exe /f")

