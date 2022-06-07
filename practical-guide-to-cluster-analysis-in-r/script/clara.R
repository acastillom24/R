
# Cargamos las funciones
source(file = "script/functions.R")

# Carga de los datos
data("USArrests")
df <- USArrests

# Validamos si tiene datos NA
validarNA(data = df)
df <- na.omit(df) #En caso la data contenga NA

# Estandarización de los datos
df <- scale(df)

# Calculo de la matrix de distancias
dist.eucl <- dist(df, method = "euclidean")

# Visualización de la matriz de distancias
library(factoextra)
fviz_dist(dist.eucl)

# Obtención del número optimo de clusters
numClusters(data = df, xintercept = 5)

library(cluster)
library(factoextra)

fviz_nbclust(df, pam, method = "silhouette") +
  theme_classic()

# Formación de los clusters
set.seed(123)
pam.res <- pam(
  x = df, 
  k = 2)

# Calculo de la mediana para cada variable de los datos originales
aggregate(df, by=list(cluster=pam.res$cluster), mean)

# Asignar los clustersa la data original
dd <- cbind(USArrests, cluster = pam.res$cluster)

# Grafico de los clusters
fviz_cluster(pam.res,
             palette = c("#00AFBB", "#FC4E07"), # color palette
             ellipse.type = "t", # Concentration ellipse
             repel = TRUE, # Avoid label overplotting (slow)
             ggtheme = theme_classic()
)
