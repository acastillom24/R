
# Info from:
## https://www.youtube.com/watch?v=SwVCfiJNfwg

# Cargamos las funciones
source(file = "script/functions.R")

# Carga de los datos
data("USArrests")
df <- USArrests
df <- read.csv(file = "data/Mall_Customers.csv")
df <- df[, -c(1:3)]

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

# Formación de los clusters
set.seed(123)
km.res <- kmeans(x = df, centers = 5, nstart = 25)

# Calculo de la mediana para cada variable de los datos originales
aggregate(df, by=list(cluster=km.res$cluster), mean)

# Asignar los clustersa la data original
dd <- cbind(df, cluster = km.res$cluster)

# Grafico de los clusters
fviz_cluster(km.res, data = df,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07", "#F704E4"),
             ellipse.type = "euclid", # Concentration ellipse
             star.plot = TRUE, # Add segments from centroids to items
             repel = TRUE, # Avoid label overplotting (slow)
             ggtheme = theme_minimal()
)