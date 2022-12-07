# Carga de bibliotecas
library(dplyr) # for glimpse()
library(tidyr) # for nest(), unnest()
library(purrr) # for map()
library(stargazer) # for stargazer()
library(report) # for report()

# Ejercicios
## Usando la base de datos storm del paquete dplyr, calcula la velocidad 
## promedio y diámetro promedio (hu_diameter) de las tormentas declaradas 
## huracanes por año

storms <- dplyr::storms

storms %>% glimpse()

storms %>% 
  filter(status == "hurricane") %>% 
  group_by(year) %>% 
  summarise(
    promedio_velocidad = mean(x = wind, na.rm = T),
    promedio_diametro = mean(x = hurricane_force_diameter, na.rm = T)) %>% 
  print(x = ., n = nrow(.))

## Usando la base de datos iris crea un inline code que diga cuál es la media 
## del largo del pétalo de la especie Iris virginica

data(iris)

iris %>% glimpse()

iris %>% 
  filter(Species == "virginica") %>% 
  summarise(media_largo_petalo = mean(Petal.Length))

## Crear dos modelos lineales para la base de datos mtcars uno para autos de 
## cambios automáticos y uno para autos de cambios manuales basados en el peso 
## del automóvil

data("mtcars")

mtcars %>% glimpse()

nest_mtcars <- 
  mtcars %>% 
  group_by(am) %>% 
  nest() %>% 
  mutate(
    modelos = map(
    .x = data,
    .f = ~ lm(formula = mpg ~ wt, data = .x)),
    reports = map(
      .x = modelos,
      .f = report))

stargazer( # Resultado del modelo
  nest_mtcars$modelos, 
  type = "text", 
  single.row = T)
