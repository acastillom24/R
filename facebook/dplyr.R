
# Biblioteca
library(dplyr)

# Carga de datos
data("mtcars")
mtcars %>% head(10)

# Agregar Columnas

## Agregar una columna al final del marco de datos
mtcars %>% 
  mutate(columnaNueva1 = 1) %>% 
  head(10)

## Agregar una columna antes de una otra columna (.before)
mtcars %>% 
  mutate(
    columnaNueva2 = 2, 
    .before = cyl) %>% 
  head(10)

## Agregar una columna despues de una otra columna (.after)
mtcars %>% 
  mutate(
    columnaNueva3 = 3, 
    .before = hp) %>% 
  head(10)

# Path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Descargar datos
download.file(
  url = "https://ndownloader.figshare.com/files/9282364",
  destfile = "data/boulder-precip.csv",
  method = "libcurl")

download.file(
  url = "https://ndownloader.figshare.com/files/7010681",
  destfile = "data/boulder-precip-v02.csv",
  method = "libcurl")


# Carga de datos
df <- read.csv(
  file = "data/boulder-precip-v02.csv", 
  col.names = c("ID", "DATE", "PRECIP"),
  colClasses = c("character", "Date", "numeric"))

library(lubridate)

df %>% 
  group_by(
    month = floor_date(
      DATE,
      unit = "year")) %>% 
  summarise(sum_precip = sum(PRECIP))

