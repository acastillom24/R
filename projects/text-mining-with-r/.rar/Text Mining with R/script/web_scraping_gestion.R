
# install.packages("readr")
# install.packages("rvest")
# install.packages("dplyr") - install.packages("tidyverse")
# install.packages("stringr")

library(readr)
library(rvest)
library(dplyr)
library(stringr)

# Importamos los links de donde se va a extraer el contenido de los diarios
NotasPeriodisticas <- read_csv("data/NotasPeriodisticas.txt",
                               col_names = F)

# Verificamos que todos los links sean unicos
NotasPeriodisticas <- NotasPeriodisticas[!duplicated(NotasPeriodisticas), ]

Gestion <- list()

for(i in 1:nrow(NotasPeriodisticas)){
  
  url <- NotasPeriodisticas[i,1]
  url <- paste0("",NotasPeriodisticas[i,1])
  
  # sesión inicial en la pagina web
  html_gestion <- html_session(url)
  # Extraccion de la fecha
  fecha <- html_gestion %>% 
    html_nodes("div.story-content__date > time") %>% 
    html_text() %>% 
    str_trim(side = "both")
  # Extraccion del titulo
  titulo <- html_gestion %>% 
    html_nodes(xpath ='//*[@id="fusion-app"]/div[3]/div[2]/section/div[1]/div[5]/h1') %>% 
    html_text() %>%
    str_trim(side = "both")
  # Extraccion del subtitulo
  subtitulo <- html_gestion %>% 
    html_nodes(xpath ='//*[@id="fusion-app"]/div[3]/div[2]/section/div[1]/div[5]/h2') %>% 
    html_text() %>%
    str_trim(side = "both")
  # Extraccion del producto
  producto <- html_gestion %>% 
    html_nodes(xpath = '//*[@id="fusion-app"]/div[3]/div[2]/section/div[2]/div[2]/picture/figcaption') %>% 
    html_text() %>%
    str_trim(side = "both")
  # Extraccion de la nota
  nota <- html_gestion %>% 
    html_nodes(xpath ='//*[@id="contenedor"]/section') %>% 
    html_text() %>%
    str_remove("[\r\n]") %>% 
    str_trim(side = "both")
  
  Gestion[i] <- list(data.frame(c("Fecha", "Titulo", "Subtitulo", "Producto","Nota"),
                                c(fecha, titulo, subtitulo, producto, nota)))
  
  # No es necesario, solo se realizo con la finalidad de ver la iteración de cada link
  print(paste("Diario-",i))
  
}

save(Gestion, file = "data/Gestion.RData")
