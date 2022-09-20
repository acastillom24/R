acPiramide <- function(data, intervals = NULL, digits = 0, labels = NULL, 
                       und = NULL, color = NULL, title = NULL, htitle = 0.5, 
                       sizetitle = 20, subtitle = NULL, hsubtitle = 0.5, 
                       sizesubtitle = 10){
  
  require(ggplot2)
  
  data <- as.data.frame(data)
  
  p <- ggplot(data = data, aes(x = data[,1], y = data[,3], fill = data[,2])) + 
    geom_bar(mapping = aes(y = data[,3]), stat = "identity")
  if(is.null(labels)){
    p <- p + scale_y_continuous(breaks = intervals, 
                                labels = formatC(abs(intervals), format = "f", 
                                                 big.mark = ",", 
                                                 digits = digits))
  }else{
    p <- p + scale_y_continuous(breaks = intervals, 
                                labels = paste0(abs(labels), und))
  }
  p + coord_flip() +
    scale_fill_brewer(palette = color) +
    theme_bw() +
    labs(x = "", y = "", title = title, subtitle = subtitle, fill = "Sexo") +
    theme(plot.title = element_text(hjust = htitle, size = sizetitle),
          plot.subtitle = element_text(hjust = hsubtitle, size = sizesubtitle))
}

acIntervals <- function(data){
  
  intervals <- pretty(c(min(data[,3]),0,max(data[,3])))
  
  divSup <- max(pretty(c(min(data[,3]),0,max(data[,3]))))
  divInf <- as.numeric(substr(max(pretty(c(min(data[,3]),0,
                                           max(data[,3])))), 1, 1))
  
  labels <- pretty(c(min(data[,3]),0, max(data[,3]))) / (divSup / divInf)
  
  result <- list(intervals = intervals,
                 labels = labels)
  
  return(result)
}
