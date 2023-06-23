import breeze.linalg.{DenseMatrix, DenseVector}
import breeze.numerics.sigmoid

class NeuralNetwork(inputSize: Int, hiddenSize: Int, outputSize: Int) {
  var weights1: DenseMatrix[Double] = DenseMatrix.rand(hiddenSize, inputSize)
  var weights2: DenseMatrix[Double] = DenseMatrix.rand(outputSize, hiddenSize)

  var bias1: DenseVector[Double] = DenseVector.zeros(hiddenSize)
  var bias2: DenseVector[Double] = DenseVector.zeros(outputSize)

  def forwardPropagation(inputs: DenseVector[Double]): DenseVector[Double] = {
    val hiddenLayer = sigmoid(weights1 * inputs + bias1)
    val outputLayer = sigmoid(weights2 * hiddenLayer + bias2)
    outputLayer
  }

  def train(inputs: DenseMatrix[Double], targets: DenseMatrix[Double], learningRate: Double, epochs: Int): Unit = {
    val numSamples = inputs.rows

    for (_ <- 0 until epochs) {
      for (i <- 0 until numSamples) {
        val input = inputs(i, ::).t
        val target = targets(i, ::).t

        val hiddenLayer = sigmoid(weights1 * input + bias1)
        val outputLayer = sigmoid(weights2 * hiddenLayer + bias2)

        val outputError = target - outputLayer
        val outputDelta = outputError *:* (outputLayer * (1.0 - outputLayer))

        val hiddenError = (weights2.t * outputDelta)
        val hiddenDelta = hiddenError *:* (hiddenLayer * (1.0 - hiddenLayer))

        weights2 += learningRate * outputDelta * hiddenLayer.t
        bias2 += learningRate * outputDelta
        weights1 += learningRate * hiddenDelta * input.t
        bias1 += learningRate * hiddenDelta
      }
    }
  }
}

object Main extends App {
  // Training data
  val inputs = DenseMatrix((0.0, 0.0), (0.0, 1.0), (1.0, 0.0), (1.0, 1.0))
  val targets = DenseMatrix((0.0), (1.0), (1.0), (0.0))

  // Create the neural network
  val inputSize = 2
  val hiddenSize = 4
  val outputSize = 1
  val learningRate = 0.1
  val epochs = 1000

  val neuralNetwork = new NeuralNetwork(inputSize, hiddenSize, outputSize)

  // Train the neural network
  neuralNetwork.train(inputs, targets, learningRate, epochs)

  // Test the trained neural network
  for (i <- 0 until inputs.rows) {
    val input = inputs(i, ::).t
    val output = neuralNetwork.forwardPropagation(input)
    println(s"Input: $input, Predicted Output: $output")
  }
}
