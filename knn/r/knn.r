# Structure to represent a data point
DataPoint <- function(x, y, label) {
  list(x = x, y = y, label = label)
}

# Function to calculate Euclidean distance between two data points
calculateDistance <- function(p1, p2) {
  dx <- p2$x - p1$x
  dy <- p2$y - p1$y
  sqrt(dx^2 + dy^2)
}

# Function to perform KNN classification
classify <- function(trainingData, testPoint, k) {
  # Calculate distances to all training data points
  distances <- sapply(trainingData, function(dataPoint) calculateDistance(dataPoint, testPoint))

  # Sort the distances in ascending order
  sortedDistances <- sort(distances)

  # Count the occurrences of each label among the k nearest neighbors
  labelCount <- table(trainingData[order(distances)][1:k]$label)

  # Return the label with the highest count
  names(labelCount)[which.max(labelCount)]
}

# Training data
trainingData <- list(
  DataPoint(2.0, 4.0, 0),
  DataPoint(4.0, 6.0, 0),
  DataPoint(4.0, 8.0, 1),
  DataPoint(6.0, 4.0, 1),
  DataPoint(6.0, 6.0, 1)
)

# Test data point
testPoint <- DataPoint(5.0, 5.0, 0)

# Perform KNN classification
k <- 3
predictedLabel <- classify(trainingData, testPoint, k)

# Print the predicted label
cat("Predicted label:", predictedLabel, "\n")

