import scala.util.Random

class HiddenLayer(hiddenSize: Int, inputSize: Int) {
  val weights: Array[Array[Double]] = Array.fill(hiddenSize, inputSize)(Random.nextDouble() - 0.5)
  val bias: Array[Double] = Array.fill(hiddenSize)(Random.nextDouble() - 0.5)
}

class OutputLayer(outputSize: Int, hiddenSize: Int) {
  val weights: Array[Array[Double]] = Array.fill(outputSize, hiddenSize)(Random.nextDouble() - 0.5)
  val bias: Array[Double] = Array.fill(outputSize)(Random.nextDouble() - 0.5)
}

val InputSize: Int = 64
val HiddenSize: Int = 128
val OutputSize: Int = 10
val LearningRate: Double = 0.01
val Epochs: Int = 10

def sigmoid(x: Double): Double = 1.0 / (1.0 + math.exp(-x))

def forwardPropagation(input: Array[Double], hiddenLayer: HiddenLayer, outputLayer: OutputLayer): Array[Double] = {
  val hiddenOutput: Array[Double] = hiddenLayer.bias.zip(hiddenLayer.weights).map { case (b, w) =>
    sigmoid(b + (w, input).zipped.map(_ * _).sum)
  }

  val output: Array[Double] = outputLayer.bias.zip(outputLayer.weights).map { case (b, w) =>
    sigmoid(b + (w, hiddenOutput).zipped.map(_ * _).sum)
  }

  output
}

def backPropagation(input: Array[Double], target: Array[Double], hiddenLayer: HiddenLayer, outputLayer: OutputLayer): Unit = {
  val hiddenOutput: Array[Double] = hiddenLayer.bias.zip(hiddenLayer.weights).map { case (b, w) =>
    sigmoid(b + (w, input).zipped.map(_ * _).sum)
  }
  val output: Array[Double] = forwardPropagation(input, hiddenLayer, outputLayer)

  val outputDelta: Array[Double] = output.zip(target).map { case (o, t) =>
    (o - t) * o * (1 - o)
  }
  val hiddenDelta: Array[Double] = outputLayer.weights.transpose.map { w =>
    (w, outputDelta, hiddenOutput).zipped.map(_ * _).sum * hiddenOutput.map(1 - _).product
  }

  outputLayer.weights.indices.foreach { i =>
    outputLayer.weights(i) = outputLayer.weights(i).zip(hiddenOutput).map { case (weight, hidden) =>
      weight - LearningRate * outputDelta(i) * hidden
    }
  }
  outputLayer.bias.indices.foreach { i =>
    outputLayer.bias(i) -= LearningRate * outputDelta(i)
  }

  hiddenLayer.weights.indices.foreach { i =>
    hiddenLayer.weights(i) = hiddenLayer.weights(i).zip(input).map { case (weight, in) =>
      weight - LearningRate * hiddenDelta(i) * in
    }
  }
  hiddenLayer.bias.indices.foreach { i =>
    hiddenLayer.bias(i) -= LearningRate * hiddenDelta(i)
  }
}

val input: Array[Double] = /* Input values here */
val target: Array[Double] = /* Target values here */

val hiddenLayer = new HiddenLayer(HiddenSize, InputSize)
val outputLayer = new OutputLayer(OutputSize, HiddenSize)

for (_ <- 1 to Epochs) {
  backPropagation(input, target, hiddenLayer, outputLayer)
}

val output: Array[Double] = forwardPropagation(input, hiddenLayer, outputLayer)

println("Output: " + output.mkString(", "))
