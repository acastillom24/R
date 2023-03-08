# Install and load packages
install.packages("factoextra")

library(factoextra)

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
  FUNcluster = kmeans, 
  method = "wss", 
  diss = dist(x = data, method = "euclidean"), 
  k.max = 12, 
  iter.max = 10, 
  nstart = 1) +
  ggplot2::geom_vline(xintercept = 4, linetype = 2)

# Choose value of K
k <- 4

# Run K-means algorithm
## The kmeans() function returns an object that contains the following information:
### - Cluster centers: The coordinates of the cluster centers.
### - Cluster sizes: The number of observations in each cluster.
### - Within-cluster sum of squares: The sum of squared distances between each 
### observation and its assigned cluster center.
kmeans_model <- kmeans(data, k, iter.max = 15, nstart = 25)

# Print the results
print(kmeans_model)

kmeans_model$centers
kmeans_model$size
kmeans_model$withinss

# Visualizing k-means clusters
factoextra::fviz_cluster(
  kmeans_model, 
  data = data,
  palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
  ellipse.type = "euclid", # Concentration ellipse
  star.plot = TRUE, # Add segments from centroids to items
  repel = TRUE, # Avoid label overplotting (slow)
  ggtheme = ggplot2::theme_minimal())

# Compute the mean of each variables by clusters using the original data
aggregate(data, by=list(cluster=kmeans_model$cluster), mean)

# Add the point classifications to the original data
cbind(data, cluster = kmeans_model$cluster)