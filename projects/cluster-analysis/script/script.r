
# Carga del daset USArrests
data(USArrests)
# Números aleatorios para seleccionar la muestra
set.seed(2415)
idex_sample <- sample(1:dim(USArrests)[1], 15)
# Selección de la muestra
df_sample <- USArrests[idex_sample, ]
# Estandarización de variables
df_scale <- scale(df_sample)

# Distancia euclidiana
dis_euclidean <- dist(df_scale, method = "euclidean")
