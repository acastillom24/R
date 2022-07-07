
cargar_datos <- function(file = NULL, delim = ",", skip_empty_rows = FALSE){
  if(!is.null(file)){
    require(readr)
    
    result <- 
      read_delim(
        file = file, 
        delim = delim, 
        skip_empty_rows = skip_empty_rows,
        show_col_types = FALSE)
    
    return(as.data.frame(result))
    
  }
}

validar_NA <- function(data = NULL){
  if(!is.null(data)){
    require(dplyr)
    
    nrow = data %>% 
      skimr::skim() %>% 
      select(
        skim_variable, 
        n_missing, 
        complete_rate) %>% 
      filter(complete_rate < 1) %>% 
      nrow
    
    if(nrow > 0){
      result = "La data contiene NA"
    }else{
      result = "La data no contiene NA"
    }
    
    return(result)
    
  }
}
 