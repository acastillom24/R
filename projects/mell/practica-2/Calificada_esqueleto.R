# Paso previo: Configurar el "Working directory" a la
# carpeta donde se encuentre la data para la parte calificada

##############
# Calificada #
##############

library(dplyr)
library(ggplot2)

df_facturas = read.csv('facturas.csv', sep=',')
df_productos = read.csv('productos.csv', sep=',')
df_productos_vendidos = read.csv('productos_vendidos.csv', sep=',')
df_productos_vendidos = df_productos_vendidos %>% 
  mutate(idfactura = as.factor(idfactura),
         idproducto = as.factor(idproducto))

# 1 a)


# 1 b)


# 2 a)


# 2 b)


# 3 a)


