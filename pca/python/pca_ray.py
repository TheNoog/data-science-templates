from ray import tune
from ray.tune.integration.sklearn import PCA

# Load the data.
data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Create a PCA model.
pca = PCA(n_components=2)

# Fit the model to the data.
pca.fit(data)

# Transform the data.
transformed_data = pca.transform(data)

# Print the principal components.
print(transformed_data)

# Tune the PCA parameters.
analysis = tune.run(
    pca,
    config={"n_components": tune.choice([2, 3, 4])},
    num_samples=3,
)

# Get the best PCA model.
best_pca = analysis.best_config.get("pca", None)

# Print the best PCA model's parameters.
print(best_pca)
