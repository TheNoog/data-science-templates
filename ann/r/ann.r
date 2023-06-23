# Define the NeuralNetwork class
NeuralNetwork <- function(inputSize, hiddenSize, outputSize, learningRate) {
  weights1 <- matrix(runif(inputSize * hiddenSize), nrow = inputSize, ncol = hiddenSize)
  weights2 <- matrix(runif(hiddenSize * outputSize), nrow = hiddenSize, ncol = outputSize)
  biases1 <- runif(hiddenSize)
  biases2 <- runif(outputSize)
  activation <- function(x) 1 / (1 + exp(-x))
  derivative <- function(x) activation(x) * (1 - activation(x))
  
  train <- function(X, y, epochs) {
    for (epoch in 1:epochs) {
      # Forward pass
      hiddenLayer <- activation(X %*% weights1 + biases1)
      outputLayer <- activation(hiddenLayer %*% weights2 + biases2)
      
      # Backpropagation
      outputLayerError <- y - outputLayer
      outputLayerDelta <- derivative(outputLayer)
      outputLayerErrorDelta <- outputLayerError * outputLayerDelta
      
      hiddenLayerError <- outputLayerErrorDelta %*% t(weights2)
      hiddenLayerDelta <- derivative(hiddenLayer)
      hiddenLayerErrorDelta <- hiddenLayerError * hiddenLayerDelta
      
      # Weight and bias adjustments
      hiddenLayerAdjustment <- t(X) %*% hiddenLayerErrorDelta
      outputLayerAdjustment <- t(hiddenLayer) %*% outputLayerErrorDelta
      
      weights1 <<- weights1 + learningRate * hiddenLayerAdjustment
      weights2 <<- weights2 + learningRate * outputLayerAdjustment
      
      biases1 <<- biases1 + learningRate * colSums(hiddenLayerErrorDelta)
      biases2 <<- biases2 + learningRate * colSums(outputLayerErrorDelta)
    }
  }
  
  predict <- function(X) {
    hiddenLayer <- activation(X %*% weights1 + biases1)
    outputLayer <- activation(hiddenLayer %*% weights2 + biases2)
    
    return(outputLayer)
  }
  
  return(list(train = train, predict = predict))
}

# Example usage
X <- matrix(c(0, 0, 0, 1, 1, 0, 1, 1), ncol = 2, byrow = TRUE)
y <- matrix(c(0, 1, 1, 0), ncol = 1)

nn <- NeuralNetwork(2, 4, 1, 0.1)
epochs <- 1000
nn$train(X, y, epochs)

predictions <- nn$predict(X)
print("Predicted Output:")
print(predictions)
