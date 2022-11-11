install.packages("swirl")

data("HairEyeColor")

HairEyeColor[,,2]

library(epitools)
library(knitr)

H <- 
  expand.table(HairEyeColor)

kable(head(H))

data(iris)

model1 <- lm(Petal.Length ~ Species, data = iris)

library(stargazer)
stargazer(model1, type = "text", single.row=TRUE)


# Usando la base de datos storm del paquete dplyr, calcula la velocidad promedio y diámetro promedio (hu_diameter) de las tormentas declaradas huracanes por año

data(dplyr::storms)

storms %>% glimpse()

storms %>% 
  filter(status == "hurricane") %>% 
  group_by(year) %>% 
  summarise(
    velocidad_promedio =  mean(wind, na.rm = T),
    diametro_promedio = mean(hurricane_force_diameter, na.rm = T)) %>% 
  arrange(year) %>% 
  print(n = 60)

# Usando la base de datos iris crea un inline code que diga cuál es la media del largo del pétalo de la especie Iris virginica

data("iris")

iris %>% glimpse()

iris %>% 
  filter(Species == "virginica") %>% 
  summarise(media_largo = mean(Petal.Length, na.rm = T))

# Crear dos modelos lineales para la base de datos mtcars uno para autos de cambios automáticos y uno para autos de cambios manuales basados en el peso del automóvil

data("mtcars")

mtcars %>% glimpse()

library(dplyr) # for %>% 
library(tidyr) # for nest()
library(purrr) # for map()
library(broom) # for tidy(), glance() & augment()
library(performance) # for check_model()
library(sjPlot) # for plot_model()
library(ggplot2)
library(report) # for report()

nest_mtcars <- 
  mtcars %>% 
  mutate(am = as.factor(am)) %>% 
  group_by(am) %>% 
  nest() %>% 
  mutate(
    models = map(
      .x = data,
      .f = ~ lm(mpg ~ wt, data = .x)),
    coefs = map(
      .x = models, 
      .f = tidy, 
      conf.int = T),
    quality = map(
      .x = models,
      .f = glance),
    preds = map(
      .x = models,
      .f = augment),
    plots_check_models = map(
      .x = models,
      .f = check_model),
    plots_models = map(
      .x = models,
      .f = plot_model,
      type = "pred",
      show.data = T),
    reports = map(
      .x = models,
      .f = report))

nest_mtcars %>% 
  unnest(coefs) %>% 
  select(-data, -models, -quality, -preds, -plots_check_models, -plots_models) %>% 
  mutate_if(is.numeric, ~round(., 2))

nest_mtcars %>% 
  unnest(quality) %>% 
  select(-data, -models, -coefs, -preds, -plots_check_models, -plots_models) %>% 
  arrange(adj.r.squared) %>% 
  glimpse()

unnest_preds <- 
  nest_mtcars %>% 
  unnest(preds) %>% 
  select(-data, -models, -coefs, -quality, -plots_check_models, -plots_models)

mtcars %>% 
  mutate(am = as.factor(am)) %>% 
ggplot(
  mapping = aes(x = wt, y = mpg, group = am)) +
  geom_point(
    mapping = aes(color = am),
    alpha = 0.2,
    shape = 1) +
  geom_smooth(
    method = "lm",
    size = 2) +
  facet_grid(~am, scales = "free") +
  geom_line(
    data = unnest_preds,
    mapping = aes(x = wt, y = .fitted, color = am))

nest_mtcars$reports




