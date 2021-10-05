
##################################################################
##                Listar archivos de un directorio              ##
##################################################################

## Step 1: Carga de bibliotecas

## Step 2: Definimos el path de trabajo

setwd(dir = r"(D:\Proyectos\GitHub\R\listar-archivos-de-un-directorio-with-R)") # Valido para R > 4.0.0

## Step 3: Listamos los archivos .csv

paths <- dir(pattern = "\\.csv$")

## Step 4: Creamos un lista que contrendra la carga de los diferentes archivos .csv

data_all_csv <- vector(mode = "list", length = length(paths))

for(i in seq_along(paths)){
  data_all_csv[[i]] <- read.csv(paths[[i]])
}

## Step 5: Otros metodos usando programacion funcional

library(purrr)

data_all_csv2 <- map(.x = paths, read.csv)

data_all_csv3 <- map_dfr(.x = paths, .f = read.csv, .id = "path")
