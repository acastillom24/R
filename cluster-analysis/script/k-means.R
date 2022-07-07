# Carga de bibliotecas
library(dplyr)

# Cargamos las funciones
source(file = "script/k-means_functions.R")

# Carga de los datos
clientes <-
  cargar_datos(file = "data/Mall_Customers.csv")

rownames(clientes) <-
  clientes$CustomerID

df <-
  clientes %>%
  select(`Annual Income (k$)`, `Spending Score (1-100)`)

# Validamos si tiene datos NA
validar_NA(data = df)

# Estandarización de los datos
df <-
  scale(df)

df.train <-
  df[1:160, ]

df.train <-
  scale(df.train)

df.test <-
  df[161:200, ]

df.test <-
  scale(df.test, attr(df.train, "scaled:center"), attr(df.train, "scaled:scale")) %>%
  as.matrix()

predict(object = kModel, df.test)

class(kModel)

kModel <- kcca(df, 5, family = kccaFamily("kmeans"))

class(km.res)
remove.packages("xml2")

install.packages("ps")

library(parameters)

res_kmeans <- cluster_analysis(df, n = 5, method = "kmeans")
predict(res_kmeans)

install.packages("ggplot2")

library(see)

install.packages("rlang")

# Cluster_analysis() , predict(), plot()

plot(res_kmeans)

install.packages("see")

# Calculo de la matriz de distancias:
## dist(): "euclidean", "maximum", "manhattan", "canberra", "binary" o "minkowski"
## get_dist(): "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski", "pearson", "spearman" o "kendall".

dist.eucl <-
  dist(
    x = df,
    method = "euclidean"
  )

dist.manhattan <-
  get_dist(
    x = df,
    method = "manhattan"
  )

# Visualizaci?n de la matriz de distancias
library(factoextra)
fviz_dist(dist.manhattan)

# Formación de los clusters
## kmeans()
### cluster: Vector de enteros (desde 1:k).
### centers: Una matriz de centros.
### totss: La suma total de cuadrados.
### withinss: Vector de suma de cuadrados dentro de un grupo.
### tot.withinss: Suma total de cuadrados dentro del grupo.
### betweenss: La suma de cuadrados entre grupos.
### size: El n?mero de puntos en cada cl?ster.
### iter: El n?mero de iteraciones.
### ifault: Indicador de un posible problema de algoritmo.

set.seed(123)

km.res <-
  kmeans(
    x = df,
    centers = 5,
    nstart = 25
  )

# Asignar los clusters a la data original
dd <-
  cbind(
    df,
    cluster = km.res$cluster
  )

# Gr?fico de los clusters
fviz_cluster(
  object = km.res,
  data = df,
  palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07", "#F704E4"),
  ellipse.type = "euclid", # Concentration ellipse
  star.plot = TRUE, # Add segments from centroids to items
  repel = TRUE, # Avoid label overplotting (slow)
  ggtheme = theme_minimal()
)
