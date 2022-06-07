# Managing many models

## Carga de bibliotecas
library(gapminder)
library(dplyr)
library(tidyr)
library(purrr)
library(broom)

## Filtrado de datos
gapminder
gapminder  <- gapminder %>% mutate(year1950 = year - 1950)

## Anidamos por continente y pais
by_country <- gapminder %>% 
group_by(continent, country) %>% 
nest()

## Función para correr modelos
country_model <- function(df){
  lm(lifeExp ~ year1950, data = df)
}

## Evaluamos el modelo
models <- by_country %>% 
mutate(
  model = data %>% map(country_model)
)

## Convertir las salidas tidy tibbles.
models <- models %>% 
mutate(
  glance = model %>% map(glance),
  rsq = glance %>% map_dbl("r.squared"),
  tidy = model %>% map(tidy),
  augment = model %>% map(augment)
)

models %>% arrange(desc(rsq))
