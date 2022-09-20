
validarNA <- function(data = NULL){
  if(!is.null(data)){
    require(dplyr)
    
    nrow = data %>% 
      skimr::skim() %>% 
      select(skim_variable, n_missing, complete_rate) %>% 
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

numClusters <- function(data = NULL, xintercept = 2){
  if(!is.null(data)){
    require(factoextra)
    return(fviz_nbclust(data, kmeans, method = "wss") +
             geom_vline(xintercept = xintercept, linetype = 2))
  }
}
