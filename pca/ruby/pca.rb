require "ruby-ml"

# Load the data.
data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Create a PCA model.
pca = PCA.new(n_components: 2)

# Fit the model to the data.
pca.fit(data)

# Transform the data.
transformed_data = pca.transform(data)

# Print the principal components.
puts transformed_data

# Tune the PCA parameters.
parameters = {
  n_components: 2..4,
}

analysis = RayTune.tune(
  pca,
  parameters,
  num_samples: 3,
)

# Get the best PCA model.
best_pca = analysis.best_config.fetch("pca")

# Print the best PCA model's parameters.
puts best_pca
