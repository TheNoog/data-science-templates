# Define the number of samples and features
N_SAMPLES <- 100
N_FEATURES <- 20

# Function to calculate the mean squared error
calculateMeanSquaredError <- function(yTrue, yPred) {
  n <- length(yTrue)
  mse <- sum((yTrue - yPred)^2) / n
  return(mse)
}

# Function to perform LASSO regression
lassoRegression <- function(X, y, alpha) {
  # Maximum number of iterations for coordinate descent
  maxIterations <- 100
  
  # Step size for coordinate descent
  stepSize <- 0.01

  nSamples <- nrow(X)
  nFeatures <- ncol(X)

  # Initialize the coefficients to zero
  coefficients <- rep(0, nFeatures)

  # Perform coordinate descent
  for (iteration in 1:maxIterations) {
    for (j in 1:nFeatures) {
      # Calculate the gradient for feature j
      gradient <- 0
      for (i in 1:nSamples) {
        pred <- sum(X[i, ] * coefficients) - X[i, j] * coefficients[j]
        gradient <- gradient + (y[i] - pred) * X[i, j]
      }

      # Update the coefficient using LASSO penalty
      if (gradient > alpha) {
        coefficients[j] <- (gradient - alpha) * stepSize
      } else if (gradient < -alpha) {
        coefficients[j] <- (gradient + alpha) * stepSize
      } else {
        coefficients[j] <- 0
      }
    }
  }

  return(coefficients)
}

# Generate some synthetic data
generateSyntheticData <- function() {
  set.seed(42)  # Use a random seed for reproducibility
  X <- matrix(runif(N_SAMPLES * N_FEATURES), ncol = N_FEATURES)
  y <- numeric(N_SAMPLES)

  for (i in 1:N_SAMPLES) {
    y[i] <- sum(X[i, ] * (1:N_FEATURES)) + 0.1 * runif(1)
  }

  return(list(X = X, y = y))
}

# Main function
main <- function() {
  # Generate some synthetic data
  data <- generateSyntheticData()
  X <- data$X
  y <- data$y

  # Split the data into training and test sets
  nTrainSamples <- round(N_SAMPLES * 0.8)
  nTestSamples <- N_SAMPLES - nTrainSamples
  XTrain <- X[1:nTrainSamples, ]
  yTrain <- y[1:nTrainSamples]
  XTest <- X[(nTrainSamples+1):N_SAMPLES, ]
  yTest <- y[(nTrainSamples+1):N_SAMPLES]

  # Perform LASSO regression
  alpha <- 0.1
  coefficients <- lassoRegression(XTrain, yTrain, alpha)

  # Make predictions on the test set
  yPred <- XTest %*% coefficients

  # Calculate the mean squared error
  mse <- calculateMeanSquaredError(yTest, yPred)
  cat("Mean Squared Error:", mse, "\n")

  # Print the true coefficients and the estimated coefficients
  cat("True Coefficients: [1.0", paste((2:N_FEATURES), collapse = " "), "]\n")
  cat("Estimated Coefficients:", coefficients, "\n")
}

# Call the main function
main()
