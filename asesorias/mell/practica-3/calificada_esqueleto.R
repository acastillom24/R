install.packages('naniar')
install.packages('dplyr')
install.packages('ggplot2')
install.packages('VIM')
install.packages('simputation')
install.packages("readxl")
install.packages("mice")
install.packages("normalr")
install.packages("caret")
install.packages("PerformanceAnalytics")

library(naniar)
library(dplyr)
library(ggplot2)
library(VIM)
library(simputation)
library(readxl)
library(mice)
library(normalr)
library(caret)
library(PerformanceAnalytics)


#Carga de archivos

base = read_xlsx(file.choose())
base = as.data.frame(apply(base,2,as.numeric))

#Carga de funciones
normalize.decscale<- function (data)
{
  
  maxvect <- apply(abs(data), 2, max)
  kvector <- ceiling(log10(maxvect))
  scalefactor <- 10^kvector
  scale(data, center = FALSE, scale = scalefactor)
}

#a)	(4 puntos) Examine la composici?n de datos faltantes. ?Qu? porcentaje tiene cada campo? ?Existe alguna interacci?n o patr?n evidente?


#b)	(2 puntos) Determine la desviaci?n est?ndar, media, m?nimo y m?ximo de la Temperatura del equipo 5 cuando hay y no hay datos faltantes en la presi?n del equipo 5. Comente.


#c)	(4 puntos) Realice la imputaci?n por la media, mediana y KNN y justifique el m?todo a utilizar para completar los datos faltantes.
#Sugerencia: Si detecta alg?n equipo con muchas mediciones faltantes, debe eliminar todas las lecturas de ese equipo: amperaje, presi?n y temperatura 


#d)	(3 puntos) Examine la data usando una matriz de distribuciones y correlaciones. ?Qu? encuentra? Adem?s calcule el valor m?ximo y m?nimo de cada campo.


#e)	(5 puntos) Realice la normalizaci?n de todos los campos utilizando los m?todos min-max, BoxCox, Z-score y Log10 y recalcule los valores m?nimos y m?ximos de cada atributo. 


#f)	(2 puntos) En una misma gr?fica coloque el boxplot de la base procesada y los boxplot normalizados y justifique el m?todo a utilizar.

