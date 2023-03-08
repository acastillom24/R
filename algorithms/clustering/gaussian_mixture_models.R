# Install and Load the necessary libraries
install.packages("mixtools")

library(mixtools)

# Load the data set
data <- data.frame(x = rnorm(100, mean = 0), y = rnorm(100, mean = 0))

# Fit the Gaussian Mixture Models
fit <- normalmixEM(data = data, k = 2)

# PLot the results
plot(fit, which = 2)
