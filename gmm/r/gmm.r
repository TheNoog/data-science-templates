library(mclust)

NSamples <- 500
NComponents <- 2

# Generate data from the first Gaussian distribution
data1 <- mvrnorm(n = NSamples/2, mu = c(0, 0), Sigma = matrix(c(1, 0, 0, 1), nrow = 2))

# Generate data from the second Gaussian distribution
data2 <- mvrnorm(n = NSamples/2, mu = c(3, 3), Sigma = matrix(c(1, 0, 0, 1), nrow = 2))

# Combine the data from both distributions
data <- rbind(data1, data2)

# Fit the Gaussian Mixture Model
gmm <- Mclust(data, G = NComponents)

# Retrieve the GMM parameters
weights <- gmm$parameters$pro
means <- gmm$parameters$mean
covariances <- gmm$parameters$variance

# Print the results
cat("Weights:\n")
cat(weights, sep = " ")
cat("\n\nMeans:\n")
print(means)
cat("\nCovariances:\n")
for (i in 1:NComponents) {
  print(covariances[[i]])
}
