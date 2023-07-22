class LogisticRegression(val featureCount: Int) {
  private val weights = DoubleArray(featureCount)
  private var bias = 0.0

  fun train(features: DoubleArray, label: Int) {
    val prediction = sigmoid(dot(features, weights) + bias)
    val error = label - prediction

    for (i in 0 until featureCount) {
      weights[i] += error * features[i]
    }
    bias += error
  }

  fun sigmoid(x: Double): Double {
    return 1.0 / (1.0 + Math.exp(-x))
  }

  fun dot(features: DoubleArray, weights: DoubleArray): Double {
    var sum = 0.0
    for (i in 0 until features.size) {
      sum += features[i] * weights[i]
    }
    return sum
  }

  fun predict(features: DoubleArray): Int {
    val prediction = sigmoid(dot(features, weights) + bias)
    return if (prediction > 0.5) 1 else 0
  }
}

fun main(args: Array<String>) {
  val features = doubleArrayOf(1.0, 2.0)
  val label = 1

  val model = LogisticRegression(2)

  for (i in 0 until 100) {
    model.train(features, label)
  }

  val newFeatures = doubleArrayOf(3.0, 4.0)
  val newLabel = model.predict(newFeatures)

  println("The predicted label is $newLabel")
}
