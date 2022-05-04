
# Carga de bibliotecas
library(dplyr)

# Carga de los datos
data(iris)

# Ordenar los datos por una variable
iris %>% 
  arrange(Sepal.Width) %>% 
  head()

# Ordenar los datos por una variable de forma descendente
iris %>% 
  arrange(desc(Sepal.Width)) %>% 
  head()

# Ordenar por mas de una variable
iris %>% 
  arrange(desc(Sepal.Width), Petal.Length) %>% 
  head()

# Ordenar agrupando por cierta variable y ordenando por otra
iris %>% 
  group_by(Species) %>% 
  summarise(media = mean(Sepal.Length)) %>% 
  arrange(desc(media)) %>% 
  head()
