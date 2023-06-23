using Random
using Distributions
using Clustering
using Plots

# Generate some random data from two Gaussian distributions
Random.seed!(0)
n_samples = 500

# Generate data from the first Gaussian distribution
mean1 = [0, 0]
cov1 = [1 0; 0 1]
data1 = rand(MultivariateNormal(mean1, cov1), Int(n_samples/2))

# Generate data from the second Gaussian distribution
mean2 = [3, 3]
cov2 = [1 0; 0 1]
data2 = rand(MultivariateNormal(mean2, cov2), Int(n_samples/2))

# Combine the data from both distributions
data = vcat(data1, data2)

# Fit the Gaussian Mixture Model
n_components = 2  # Number of Gaussian components to fit
gmm = fit(MixtureModel(MvNormal, n_components), data)

# Generate new samples from the learned model
new_samples = rand(gmm, 100)

# Plot the original data and the generated samples
scatter(data[:, 1], data[:, 2], label="Original Data")
scatter!(new_samples[:, 1], new_samples[:, 2], label="Generated Samples")
title!("Gaussian Mixture Model")
