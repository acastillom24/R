# Carga de bilbiotecas
library(rvest)
library(dplyr) 

# Definimos las variables
link <- "https://datosmacro.expansion.com/demografia/esperanza-vida"

# Obtenemos la tabla de datos de la esperanza de vida
html <- read_html(link) %>% 
  html_element(".table") %>% 
  html_table()