# Install and load 'hclust' package
install.packages("hclust")
library(hclust)

# Load data set
mydata <- read.csv("mydata.csv")

# Explore the data


# Prepare the data
## Impute or remove missing values
mydata <- na.omit(mydata)

## Scale or normalize the data
mydata_scaled <- scale(mydata)

# Calculate the distance matrix
## You can choose the distance metric you want to use, such as 'Euclidean',
## 'Manhattan', or 'Person correlation'
dist_matrix <- dist(mydata_scaled, method = "euclidean")

# Perform hierarchical clustering
## You can specify the distance metric and the linkage method you want to use.
## Common likage methods include 'complete', 'single', 'average' and 'ward'.
hc <- hclust(dist_matrix, method = "ward.D2")

# Plot the dendrogram
plot(hc)
