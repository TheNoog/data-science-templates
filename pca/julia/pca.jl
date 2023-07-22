using MultivariateStats

# Load the data
data = CSV.read("data.csv")

# Standardize the data
data = data.dropna()
data_std = (data - mean(data)) / std(data)

# Create a PCA model
pca = PCA(data_std)
pca.fit()

# Get the principal components
principal_components = pca.principal_components

# Print the principal components
println(principal_components)
