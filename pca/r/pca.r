library(tidyverse)
library(psych)

# Load the data
data <- read_csv("data.csv")

# Standardize the data
data_std <- data %>%
  select(-id) %>%
  scale()

# Create a PCA model
pca <- princomp(data_std)

# Get the principal components
principal_components <- pca$loadings

# Print the principal components
print(principal_components)
