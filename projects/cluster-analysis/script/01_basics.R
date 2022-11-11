
# Introduction to R

# Data Preparation

# 1. Rows are observations (individuals) and columns are variables
# 2. Any missing value in the data must be removed or estimated.
# 3. The data must be standardized (i.e., scaled) to make variables comparable. Recall
# that, standardization consists of transforming the variables such that they have
# mean zero and standard deviation one. Read more about data standardization
# in chapter 3.


df <- na.omit(df)
df <- scale(df)

# Required R Packages

install.packages(c("cluster", "factoextra"))

# Distance Measures

## Euclidean distance
## Manhattan distance
## Pearson correlation distance (parametric)
## Eisen cosine correlation distance (parametric)
## Spearman correlation distance (non-parametric)
## Kendall correlation distance (non-parametric)

dist.eucl <- dist(df.scaled, method = "euclidean") 
#acepted: "maximum", "manhattan", "canberra", "binary", "minkowski"

round(as.matrix(dist.eucl)[1:3, 1:3], 1)

library("factoextra")
dist.cor <- get_dist(df.scaled, method = "pearson")
round(as.matrix(dist.cor)[1:3, 1:3], 1)