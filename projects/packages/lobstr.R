# Info from:
## https://www.youtube.com/watch?v=g1h-YDWVRLc

# Install Package
install.packages("lobstr")

# Uploaded package
library(lobstr)

`%notin%` <- function(x, y) !x %in% y


x <- 
  c(1, 2, 3, 4)

y <- 
  c(2, 3, 5, 7)

x[x %notin% y]

# Step 1: Data Preparation
## readr, dplyr, tidyr, stringr, lubridate, forcats

# Step 2: Experimentation
## ggplot2, plotly, tidymodels (yardstick, parsnip, recipes, rsample, TUNE), h2o

# Step 3: Distribution
## Rmarkdown, shiny