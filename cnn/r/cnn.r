# Define HiddenLayer class
HiddenLayer <- setRefClass("HiddenLayer",
                            fields = list(weights = "matrix",
                                          bias = "numeric"),
                            methods = list(
                              initialize = function(hiddenSize, inputSize) {
                                this$weights <- matrix(runif(hiddenSize * inputSize) - 0.5, nrow = hiddenSize)
                                this$bias <- runif(hiddenSize) - 0.5
                              }
                            )
)

# Define OutputLayer class
OutputLayer <- setRefClass("OutputLayer",
                            fields = list(weights = "matrix",
                                          bias = "numeric"),
                            methods = list(
                              initialize = function(outputSize, hiddenSize) {
                                this$weights <- matrix(runif(outputSize * hiddenSize) - 0.5, nrow = outputSize)
                                this$bias <- runif(outputSize) - 0.5
                              }
                            )
)

InputSize <- 64
HiddenSize <- 128
OutputSize <- 10
LearningRate <- 0.01
Epochs <- 10

sigmoid <- function(x) {
  1 / (1 + exp(-x))
}

forwardPropagation <- function(input, hiddenLayer, outputLayer) {
  hiddenOutput <- sigmoid(hiddenLayer$bias + hiddenLayer$weights %*% input)

  output <- sigmoid(outputLayer$bias + outputLayer$weights %*% hiddenOutput)

  output
}

backPropagation <- function(input, target, hiddenLayer, outputLayer) {
  hiddenOutput <- sigmoid(hiddenLayer$bias + hiddenLayer$weights %*% input)
  output <- forwardPropagation(input, hiddenLayer, outputLayer)

  outputDelta <- (output - target) * output * (1 - output)
  hiddenDelta <- t(outputLayer$weights) %*% outputDelta * hiddenOutput * (1 - hiddenOutput)

  outputLayer$weights <- outputLayer$weights - LearningRate * outputDelta %*% t(hiddenOutput)
  outputLayer$bias <- outputLayer$bias - LearningRate * outputDelta

  hiddenLayer$weights <- hiddenLayer$weights - LearningRate * hiddenDelta %*% t(input)
  hiddenLayer$bias <- hiddenLayer$bias - LearningRate * hiddenDelta
}

input <- c(/* Input values here */)
target <- c(/* Target values here */)

hiddenLayer <- HiddenLayer$new(HiddenSize, InputSize)
outputLayer <- OutputLayer$new(OutputSize, HiddenSize)

for (epoch in 1:Epochs) {
  backPropagation(input, target, hiddenLayer, outputLayer)
}

output <- forwardPropagation(input, hiddenLayer, outputLayer)

cat("Output:", output, "\n")
