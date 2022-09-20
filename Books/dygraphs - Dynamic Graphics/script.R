
# data from:
# Apple Inc. (AAPL): https://es-us.finanzas.yahoo.com/quote/AAPL/history?p=AAPL
# Facebook, Inc. (FB): https://es-us.finanzas.yahoo.com/quote/FB/history?p=FB
# Tesla, Inc. (TSLA): https://es-us.finanzas.yahoo.com/quote/TSLA/history?p=TSLA
# Amazon.com, Inc. (AMZN): https://es-us.finanzas.yahoo.com/quote/AMZN/history?p=AMZN
# Netflix, Inc. (NFLX): https://es-us.finanzas.yahoo.com/quote/NFLX/history?p=NFLX

# Source from:
# Revolutions: https://blog.revolutionanalytics.com/2015/08/plotting-time-series-in-r.html

# Instalar paquetes necesarios --------------------------------------------

# install.packages("dygraphs")
# install.packages("xts")
# install.packages("dplR")
# install.packages("purrr")
# install.packages("ggplot2")
# install.packages("stringr")
# install.packages("fs")
# install.packages("tidyr")

# Carga de bibliotecas ----------------------------------------------------
library(dygraphs)
library(xts)
library(dplyr)
library(purrr)
library(ggplot2)
library(stringr)
library(fs)
library(tidyr)

# Establecemos el lugar de trabajo ----------------------------------------

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Carga de los datoa ------------------------------------------------------

paths <- dir_ls(path = "data/", glob = "*.csv") # Listamos todos los archivos con extension .csv
paths <- setdiff(x = paths, y = "data/AMZN.csv") # Dejamos de lado la data de Amazon
nameFiles <- gsub(pattern = "data/", 
                  replacement = "", 
                  x = gsub(pattern = ".csv", 
                           replacement = "", 
                           x = paths)) # Establecemos el nuevo nombre
paths <- as.vector(paths)
names(paths) <- nameFiles # Reemplazamos los nombres del vector

dataFinanzas <- map_dfr(.x = paths, .f = read.csv, .id = "Company") # Cargamos todos los datos de las 5 companias
dataFinanzas <- dataFinanzas %>% mutate(Company = as.factor(Company), 
                                        Date = as.Date(Date))
str(dataFinanzas)

# Grafica con ggplot2 -----------------------------------------------------

ggplot(data = dataFinanzas, 
       mapping = aes(x = Date, y = Close, colour = Company)) +
  geom_line() +
  ggtitle(paste("Closing Stock Prices:", str_c(nameFiles, collapse = ", "))) + 
  theme(plot.title = element_text(lineheight =.7, face = "bold"))

dataFinanzas_xts <- dataFinanzas %>% 
  select(Date, Close, Company) %>% 
  spread(key = Company, value = Close)

# Grafica con dygraph -----------------------------------------------------

dataFinanzas_xts <- xts(nData[,-1], order.by = nData$Date, frequency = 365)

dygraph(data = dataFinanzas_xts, 
        ylab = "Close", 
        main = paste("Closing Stock Prices:", str_c(nameFiles, collapse = ", "))) %>% 
  dySeries() %>% 
  # dyOptions(colors = c("blue","brown", "yellow", "black", "red")) %>%
  dyRangeSelector()