
# Install and load 'dbscan' package
install.packages("dbscan")
library(dbscan)

# Load data set
data <- read.csv("your_data.csv")

# Explore data set

# Apply dbscan algorithm
## Parameters
### 'eps' => The maximum distance between points in the same cluster.
### 'minPts' => The minimum number of points required to form a cluster.

dbscan_result <- dbscan::dbscan(df, eps = 0.5, minPts = 5)

# Access the cluster assignments and noise points
## Cluster assignments
plot(data, col = dbscan_result$cluster + 1)

## Noise points
plot(data[dbscan_result$noise, ], col = "black", pch = 20)