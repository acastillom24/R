ipak <- function(pkg){
  # Info from: 
  ## https://gist.github.com/stevenworthington/3178163
  
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

configDriver <- 
  function(chromever = NULL){
    if(!is.null(chromever)){
      system(
        command = "taskkill /im java.exe /f", 
        intern = FALSE, 
        ignore.stdout = FALSE)
      
      rsDriver(
        browser = "chrome",
        port = 4567L,
        chromever = "104.0.5112.79")
    }else(
      print("You need to post version of chromever")
    )
  }

searchInput <- 
  function(remDr, xpath, search){
    webElem <- 
      remDr$findElement(
        using = "xpath", 
        value = xpath)
    
    webElem$sendKeysToElement(list(search, key = "enter"))
  }

searchElements <- 
  function(remDr, xpath){
    
    webElems <- 
      remDr$findElements(
        using = "xpath", 
        value = xpath)
  }
