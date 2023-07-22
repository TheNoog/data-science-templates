logisticRegression <- function(features, label) {
  # Initialize weights and bias
  weights <- rep(0, length(features))
  bias <- 0

  # Train the model
  for (i in 1:100) {
    prediction <- sigmoid(sum(weights * features) + bias)
    error <- label - prediction

    weights <- weights + error * features
    bias <- bias + error
  }

  # Predict the label for a new data point
  newFeatures <- c(3, 4)
  newLabel <- sigmoid(sum(weights * newFeatures) + bias) > 0.5

  return(newLabel)
}

# Initialize data
features <- c(1, 2)
label <- 1

# Train the model
newLabel <- logisticRegression(features, label)

# Print the predicted label
print(newLabel)
