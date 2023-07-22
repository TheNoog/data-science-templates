import scala.math._

class LogisticRegression {

  private var weights: Array[Double] = Array.ofDim(2)
  private var bias: Double = 0.0

  def train(features: Array[Double], label: Double): Unit = {
    prediction = sigmoid(dot(features, weights) + bias)
    error = label - prediction

    for (i <- 0 until weights.length) {
      weights(i) += error * features(i)
    }
    bias += error
  }

  def sigmoid(x: Double): Double = 1.0 / (1.0 + exp(-x))

  def dot(features: Array[Double], weights: Array[Double]): Double = {
    var sum = 0.0
    for (i <- 0 until weights.length) {
      sum += features(i) * weights(i)
    }
    sum
  }

  def predict(features: Array[Double]): Int = {
    prediction = sigmoid(dot(features, weights) + bias)
    if (prediction > 0.5) 1 else 0
  }
}

object LogisticRegression {
  def main(args: Array[String]): Unit = {
    val features = Array[Double](1.0, 2.0)
    val label = 1.0

    val model = new LogisticRegression()

    for (_ <- 0 until 100) {
      model.train(features, label)
    }

    val newFeatures = Array[Double](3.0, 4.0)
    val newLabel = model.predict(newFeatures)

    println(s"The predicted label is $newLabel")
  }
}
