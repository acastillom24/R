# Install and load packages
install.packages("cluster")
install.packages("factoextra")

library(factoextra)
library(cluster)

# Load data set
data("USArrests")
data <- USArrests

# Explore the data
funModeling::df_status(data)

# Prepare the data
## Impute or remove missing values
data <- na.omit(data)

## Scale or normalize the data
data <- scale(data)

# Optimal number of clusters
factoextra::fviz_nbclust(
  x = data, 
  FUNcluster = cluster::pam, 
  method = "silhouette", 
  diss = dist(x = data, method = "euclidean"), 
  k.max = 12, 
  metric = "euclidean", 
  stand = FALSE) +
  ggplot2::theme_classic()

# Choose value of K
k <- 2

# Run K-means algorithm
## The kmeans() function returns an object that contains the following information:
### - Cluster centers: The coordinates of the cluster centers.
### - Cluster sizes: The number of observations in each cluster.
### - Within-cluster sum of squares: The sum of squared distances between each 
### observation and its assigned cluster center.
kmedois_model <- cluster::pam(data, k, metric = "euclidean", stand = FALSE)

# Print the results
print(kmeans_model)

kmedois_model$medoids
kmedois_model$clustering

# Visualizing k-means clusters
factoextra::fviz_cluster(
  kmedois_model, 
  palette = c("#00AFBB", "#FC4E07"), # color palette
  ellipse.type = "t", # Concentration ellipse
  repel = TRUE, # Avoid label overplotting (slow)
  ggtheme = ggplot2::theme_classic())

# Compute the mean of each variables by clusters using the original data
aggregate(data, by=list(cluster = kmedois_model$clustering), mean)

# Add the point classifications to the original data
cbind(data, cluster = kmedois_model$clustering)
