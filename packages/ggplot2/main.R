
# Carga de paquetes
library(ggplot2)
library(dplyr)

# Carga de datos
mpg <- mpg


mpg %>% 
ggplot() +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

mpg %>% 
  ggplot() +
  geom_point(mapping = aes(x = class, y = drv))

str(mpg)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 3)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
