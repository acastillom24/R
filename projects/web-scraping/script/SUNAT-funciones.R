consultaRUC <- 
  function(remDr, url, numRUC){
    remDr$navigate(url = url)
    Sys.sleep(3)
    
    btnInput(remDr, numRUC)
    btnBuscar(remDr)
    Sys.sleep(3)
    
    txtEmpresa <- 
      txtNombreEmpresa(remDr)
    
    btnNumeroTrabajadoresClick(remDr)
    
    Sys.sleep(3)
    
    dfNumTrabajadores <- 
      tblNumeroTrabajadores(remDr)
    
    dfNumTrabajadores <- 
      dfNumTrabajadores %>% 
      mutate(
        NombreEmpresa = txtEmpresa,
        NumRuc = numRUC)
    
    btnVolverClick(remDr)
    Sys.sleep(3)
    
    btnRepresentantesLegales(remDr)
    Sys.sleep(3)
    
    dfRepresentatesLegales <- 
      tblRepresentantesLegales(remDr)
    
    dfRepresentatesLegales <- 
      dfRepresentatesLegales %>% 
      mutate(
        NombreEmpresa = txtEmpresa,
        NumRuc = numRUC)
    
    result <- 
      list(
        NumeroTrabajadores = dfNumTrabajadores,
        RepresentantesLegales = dfRepresentatesLegales)
    
    return(result)
    
  }

btnInput <- 
  function(remDr, numRUC){
    xpath <- 
      "//div[@id='divRuc']/input" #Path Buscar RUC
    
    elemento <- 
      remDr$findElement(
        using = "xpath", 
        value = xpath)
    
    elemento$sendKeysToElement(list(numRUC))
  }

btnBuscar <- 
  function(remDr){
    xpath <- 
      "//button[@id='btnAceptar']"
    
    elemento <- 
      remDr$findElement(
        using = "xpath",
        value = xpath
      )
    
    elemento$clickElement()
  }

txtNombreEmpresa <- 
  function(remDr){
    xpath <- 
      "//div[@class='list-group']/descendant::h4[contains(text(), 'RUC')]/parent::div/following-sibling::div"
    
    elemento <- 
      remDr$findElement(
        using = "xpath",
        value = xpath
      )
    
    return(elemento$getElementText()[[1]])
  }


btnNumeroTrabajadoresClick <- 
  function(remDr){
    xpath <- 
      "//button[contains(text(), 'Trabajadores')]"
    
    elemento <- 
      remDr$findElement(
        using = "xpath",
        value = xpath
      )
    
    elemento$clickElement()
  }

tblNumeroTrabajadores <- 
  function(remDr){
    require(dplyr)
    
    html <- 
      htmlParse(file = remDr$getPageSource()[[1]])
    
    tbl <- 
      readHTMLTable(
        doc = html, 
        which = 1,
        header = F,
        encoding = "UTF-8", 
        stringsAsFactors = F, 
        as.data.frame = T)
    
    tbl <- 
      tbl %>% 
      mutate(
        V2 = as.integer(gsub(" ", "", V2)),
        V3 = as.integer(V3),
        V4 = as.integer(V4))
    
    return(tbl)
    
  }

btnVolverClick <- 
  function(remDr){
    xpath <- 
      "//button[text()='Volver']"
    
    elemento <- 
      remDr$findElement(
        using = "xpath",
        value = xpath
      )
    
    elemento$clickElement()
  }

btnRepresentantesLegales <- 
  function(remDr){
    xpath <- 
      "//button[contains(text(), 'Representante')]"
    
    elemento <- 
      remDr$findElement(
        using = "xpath",
        value = xpath
      )
    
    elemento$clickElement()
  }

tblRepresentantesLegales <- 
  function(remDr){
    require(dplyr)
    
    html <- 
      htmlParse(file = remDr$getPageSource()[[1]])
    
    tbl <- 
      readHTMLTable(
        doc = html, 
        which = 1,
        header = F,
        encoding = "UTF-8", 
        stringsAsFactors = F, 
        as.data.frame = T)
    
    return(tbl)
  }