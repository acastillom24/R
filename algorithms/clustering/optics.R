
# Install and load 'dbscan' package
install.packages("dbscan")
library(dbscan)

# Load data set

# Explore data set

# Convert data set to matrix object
data <- matrix(rnorm(500), ncol = 2)

# Apply dbscan algorithm
## Parameters
### 'eps' => The maximum distance between points in the same cluster.
### 'minPts' => The minimum number of points required to form a cluster.

optics_res <-   dbscan::optics(data, eps = 0.5, minPts = 5)

# Access the cluster assignments
clusters <-   dbscan::extractDBSCAN(optics_res, eps = 0.5, minPts = 5)

# Visualize the clusters
plot(data, col = clusters$cluster + 1, pch = 20)