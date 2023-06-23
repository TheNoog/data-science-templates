require 'rubygems'
require 'distributions'

NSamples = 500
NComponents = 2

# Generate data from the first Gaussian distribution
data1 = Distributions::Normal.rng(0, 1).sample(NSamples/2).zip(Distributions::Normal.rng(0, 1).sample(NSamples/2))

# Generate data from the second Gaussian distribution
data2 = Distributions::Normal.rng(3, 1).sample(NSamples/2).zip(Distributions::Normal.rng(3, 1).sample(NSamples/2))

# Combine the data from both distributions
data = data1 + data2

# Fit the Gaussian Mixture Model
gmm = Distributions::GMM.new(NComponents, data)

# Retrieve the GMM parameters
weights = gmm.weights
means = gmm.means
covariances = gmm.covariances

# Print the results
puts "Weights:"
puts weights.join(' ')

puts "\nMeans:"
means.each { |mean| puts mean.join(' ') }

puts "\nCovariances:"
covariances.each { |cov| puts cov.to_a.join(' ') }
