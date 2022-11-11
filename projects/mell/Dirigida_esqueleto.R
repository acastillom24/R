########################
# Librerías a instalar #
########################

# Descomentar las lineas abajo y ejecutarlas

# install.packages('dplyr')
# install.packages('ggplot2')
# install.packages('tidyr')
# install.packages('magrittr')

# Paso previo: tras instalar las librerías, configurar el "Working directory" a la
# carpeta donde se encuentre la data 'data_dirigida.csv'

############
# Dirigida #
############

library(dplyr)
library(ggplot2)

df_compras = read.csv(file.choose(), sep=',')

# a) Cree una columna extra a df_compras que indique con TRUE/FALSE si una compra
# tiene un precio superior a 25 unidades monetarias. Llame a esta columna "IndicadorPrecioAlto"

df_compras <- 
  df_compras %>% 
  mutate(IndicadorPrecioAlto = if_else(PrecioEntrada > 25, TRUE, FALSE))

df_compras$IndicadorPrecioAlto <- if_else(df_compras$PrecioEntrada > 25, TRUE, FALSE)

# b) Obtenga una estadística de frecuencias sobre la variable categórica "Categoria"
# de df_compras

df_compras %>% 
  group_by(Categoria) %>% 
  summarise(Frecuencia = n()) # n(): Contar - frecuencia

# c) Por cada categoría de entrada, obtener la media, la desviación estándar
# y el total de dinero gastado en compras
# ¿Cuál es la más cara, en promedio, y la de mayor variabilidad?

df_compras %>% 
  group_by(Categoria) %>% 
  summarise(
    Max = max(PrecioEntrada),
    Min = min(PrecioEntrada),
    Media = mean(PrecioEntrada), 
    DesStd = sqrt(var(PrecioEntrada)), 
    Total = sum(PrecioEntrada))

mean(df_compras[df_compras$Categoria == "1_Normal", "PrecioEntrada"])
mean(df_compras[df_compras$Categoria == "2_Especial", "PrecioEntrada"])
mean(df_compras[df_compras$Categoria == "3_VIP", "PrecioEntrada"])

sum(df_compras[df_compras$Categoria == "1_Normal", "PrecioEntrada"])
sum(df_compras[df_compras$Categoria == "2_Especial", "PrecioEntrada"])
sum(df_compras[df_compras$Categoria == "3_VIP", "PrecioEntrada"])

sqrt(var(df_compras[df_compras$Categoria == "1_Normal", "PrecioEntrada"]))
sqrt(var(df_compras[df_compras$Categoria == "2_Especial", "PrecioEntrada"]))
sqrt(var(df_compras[df_compras$Categoria == "3_VIP", "PrecioEntrada"]))

# d) Obtenga la misma información del inciso c), pero considerando únicamente a las
# categorías "1_Normal" y "2_Especial" y los días mayores a 20.

df_compras %>% 
  filter(
    Categoria %in% c("1_Normal", "2_Especial"),
    Dia > 20) %>% 
  summarise(
    Media = mean(PrecioEntrada), 
    DesStd = sqrt(var(PrecioEntrada)), 
    Total = sum(PrecioEntrada))

mean(df_compras[df_compras$Categoria %in% c("1_Normal", "2_Especial") & df_compras$Dia > 20, "PrecioEntrada"])
sum(df_compras[df_compras$Categoria %in% c("1_Normal", "2_Especial") & df_compras$Dia > 20, "PrecioEntrada"])
sqrt(var(df_compras[df_compras$Categoria %in% c("1_Normal", "2_Especial") & df_compras$Dia > 20, "PrecioEntrada"]))

# e) Para la categoría '2_Especial', por día, obtenga la cantidad de registros y el promedio de precios y analice si hay tendencia.
# Ordene los resultados de manera ascendente según día

pregunta_e <- 
  df_compras %>% 
  filter(
    Categoria == "2_Especial") %>% 
  group_by(Dia) %>% 
  summarise(
    Frecuencia = n(),
    Media = mean(PrecioEntrada)) %>% 
  arrange(Dia) # Para ordenar de manera ascendente, en caso contrario usar (-)

# Verificar si hay tendencia
ggplot(
  data = pregunta_e, 
  mapping = aes(x = Dia, y = Media)) + 
  geom_line()

# f) Utilicemos gráficas para evaluar mejor el comportamiento de los precios en el tiempo.
# Construya un gráfico de dispersión y comente sobre los comportamientos que observa

ggplot(
  data = df_compras, 
  mapping = aes(x = Dia, y = PrecioEntrada)) + 
  geom_point()

# g) Tomando en cuenta la gráfica del inciso f), genere una distinción por categoría
# y comente sobre los patrones que observa en la data. Sugerencia: experimente con
# los argumentos "fill", "color" y "pch" dentro de la función "aes()"

ggplot(
  data = df_compras, 
  mapping = aes(x = Dia, y = PrecioEntrada)) + 
  geom_point(mapping = aes(color = Categoria, pch = Categoria))

# h) Cree un grafico de cajas (boxplot) para el precio de entrada por categoría

ggplot(
  data = df_compras, 
  mapping = aes(x = Categoria, y = PrecioEntrada)) + 
  geom_boxplot()

# i) Cree un histograma para el precio de entrada por categoría (pruebe con "fill" y "color")
ggplot(
  data = df_compras, 
  mapping = aes(x = PrecioEntrada)) + 
  geom_histogram(mapping = aes(color = Categoria), fill = "white")

# j) Cree un diagrama de barras para evaluar la frecuencia por categoría (pruebe con "fill" y "color")

ggplot(
  data = df_compras, 
  mapping = aes(x = Categoria)) + 
  geom_bar(mapping = aes(color = Categoria), fill = "white")
