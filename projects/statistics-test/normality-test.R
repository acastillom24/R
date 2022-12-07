# Info from:
## https://glue.tidyverse.org/
## https://rquer.netlify.app/distribution/distribution_normal/
## https://estadistica-dma.ulpgc.es/cursoR4ULPGC/9c-grafHistograma.html
## https://www.cienciadedatos.net/documentos/pystats06-analisis-normalidad-python.html

# Carga de bibliotecas
library(dplyr)
library(skimr)
library(tidyr)
library(purrr)
library(ggplot2)
library(ggthemes) # For: theme_gdocs
library(glue) # For: glue

# Carga de los datos
url <-
  "https://raw.githubusercontent.com/JoaquinAmatRodrigo/Estadistica-machine-learning-python/master/data/Howell1.csv"

dfHowell <-
  read.csv(file = url, header = T)

# Análisis exploratorio
dfHowell |>
  skim()

# Análisis de Normalidad

## Análisis gráfico
nest_dfHowell <-
  dfHowell |>
  group_by(male) |>
  nest() |>
  mutate(graf_hist = )


dfHowell |>
  ggplot(mapping = aes(x = height)) +
  geom_histogram(aes(y =..density..),
                 color = "orange",
                 fill = "orange",
                 bins = 30, alpha = 0.25) +
  stat_function(fun = dnorm,
                n = 1000,
                args = list(mean = mean(dfHowell$height),
                            sd = sd(dfHowell$height)),
                col = "orange",
                size = 1) +
  labs(title = glue("Distribución del {names(dfHowell)[1]}"),
       subtitle = bquote('Height: ('~mu==.(mean(dfHowell$height))~','~sigma^{2}==.(sd(dfHowell$height))^{2}~') '),
       x = "",
       y = "") +
  theme_gdocs() +
  theme(legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))


install.packages("ggthemes")

names(dfHowell)[1]

density(dfHowell$height)

qqnorm(dfHowell$height)


map(.x = dfHowell, .f = function(x) return(list(mean = mean(x),
                                                median = median(x))))

# Test de shapiro wilks

## Hn: Los datos siguen una distribución normal
## Ha: Los datos no siguen una distribución normal

shapiro.test(x = dfHowell$height)
