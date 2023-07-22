import numpy as np
import pandas as pd
from sklearn.decomposition import PCA

# Load the data
data = pd.read_csv("data.csv")

# Standardize the data
data = data.dropna()
data_std = (data - data.mean()) / data.std()

# Create a PCA model
pca = PCA()
pca.fit(data_std)

# Get the principal components
principal_components = pca.components_

# Print the principal components
print(principal_components)
