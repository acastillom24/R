
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

hampelFilter <- 
  function(x){
    sup <- 
      median(x) + 3 * mad(x)
    inf <- 
      median(x) - 3 * mad(x)
    
    output <- 
      list(
        inf = inf,
        sup = sup
      )
    
    return(output)
  }

dataValidation <- function(df = NULL){
  if(!is.null(df)){
    require(skimr)
    require(dplyr)
    
    # Identificar las variables con datos faltantes
    resumen <- 
      df %>%
      skim() %>% 
      select(
        skim_variable, n_missing, complete_rate) %>%
      filter(
        complete_rate < 1) %>%
      mutate(
        p_incomplete = ((1 - complete_rate) * 100)) %>%
      select(
        skim_variable, n_missing, p_incomplete)
    
    if(nrow(resumen) == 0){
      output <- 
        "No existen observaciones faltantes en ninguna variable"
    }else{
      # Identificar las observaciones con datos faltantes
      dataIncomplete <- 
        filter_all(
          df, any_vars(is.na(.)))
      
      dataComplete <- 
        filter_all(
          df, all_vars(!is.na(.)))
      
      output <- 
        list(
          resumen = resumen,
          dataIncomplete = dataIncomplete,
          dataComplete = dataComplete)
    }
    
    return(output)
  }
}