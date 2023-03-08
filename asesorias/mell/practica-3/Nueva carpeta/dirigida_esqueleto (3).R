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
#Explicar también con working directory

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

#Tema: Imputación de datos faltantes
#-------------------------------------------------------------------------------------------

#a) Examine la composición de datos faltantes. ¿Que porcentaje hay por cada campo?
#¿Visualiza alguna interacción? ¿Hay faltantes en Criminalidad y Antiguedad a la vez?


#b) Determine la desviacion estandar, media, mínimo y máximo de la variable Precio_Valor
# cuando hay y no hay datos faltantes en Criminalidad ¿los grupos son muy diferentes?


#c) Realice la imputación por la media, la mediana y por KNN (vecinos más cercanos)


#Suponga que por las condiciones de la base de datos se imputa por la mediana.
#Considere que se renombra a la base imputada como "Base_Procesada".


#Tema: Normalización
#-------------------------------------------------------------------------------------------

#d)	Examine la data usando una matriz de distribuciones y correlaciones. ¿Qué encuentra?


#e)	Realice un diagrama de cajas para cada una de las variables. ¿Existen outliers?


#f)	Determine los valores máximos y mínimos para cada variable.¿Nota rangos muy grandes?


#g) Realice la normalización de todos los campos utilizando los métodos min-max, BoxCox, Zscore y Log10 y 
#recalcule los valores mínimos y máximos de cada atributo y comente sobre el cambio en los rangos.


#h) En una misma gráfica coloque los boxplots de la base procesada y las bases normalizadas ¿Qué método funciona mejor para estos datos?

