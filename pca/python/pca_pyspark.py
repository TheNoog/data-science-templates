from pyspark.ml.feature import PCA

# Load the data.
data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
df = spark.createDataFrame(data, ["x1", "x2", "x3"])

# Create a PCA model.
pca = PCA(n_components=2)

# Fit the model to the data.
pca_model = pca.fit(df)

# Transform the data.
pca_features = pca_model.transform(df)

# Print the principal components.
print(pca_features.select("PC1", "PC2").show())
