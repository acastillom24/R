
# Instalar paquetes
packages <- c("binman", "curl", "dplyr", "robotstxt", "RSelenium")
ipak(packages)

# Establecer el driver
binman::list_versions(appname = "chromedriver")
driver <- 
  configDriver(chromever = "104.0.5112.79")

# Establecer el cliente
remDr <- 
  driver$client

remDr$open()
remDr$maxWindowSize()

# Url de la web
url <- 
  "https://www.amazon.com/-/es/ref=nav_logo?language=es_PE"

# Verificar si el link tiene permisos legales para acceder
paths_allowed(paths = url)

# Navegar a la url
remDr$navigate(
  url = url)

# Busqueda
xpathBusqueda <- 
  "//input[@id='twotabsearchtextbox']"

searchInput(
  remDr = remDr, 
  xpath = xpathBusqueda, 
  search = "Mochilas")


xpathElements <- 
  "//div[@data-component-type='s-search-result']/descendant::h2/a/span"

webElems <- 
  searchElements(remDr = remDr, xpath = xpathElements)


resHeaders <- unlist(lapply(webElems, function(x) {x$getElementText()}))
resHeaders

xpathElements <- 
  "//div[@data-component-type='s-search-result']/descendant::h2/a"

webElems <- 
  searchElements(remDr = remDr, xpath = xpathElements)

resHeaders <- unlist(lapply(webElems, function(x) {x$getElementAttribute("href")}))
resHeaders

remDr$close()
