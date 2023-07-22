class RNN(inputDim: Int, hiddenDim: Int, outputDim: Int) {

  val weights = Array.fill(inputDim)(Array.fill(hiddenDim)(scala.util.Random.nextDouble - 0.5))
  val biases = Array.fill(hiddenDim)(scala.util.Random.nextDouble - 0.5)

  val h = Array.fill(hiddenDim)(0.0)

  def train(data: Array[Array[Double]]): Unit = {
    for (sequence <- data) {
      for (t <- sequence) {
        val z = 0.0
        for (i <- 0 until inputDim) {
          z += t(i) * weights(i)(h.size)
        }
        h = h :+ scala.math.tanh(z + biases(h.size))
      }
    }
  }

  def predict(data: Array[Double]): Array[Double] = {
    val predictions = Array.ofDim[Double](data.length)
    h = Array.fill(hiddenDim)(0.0)
    for (t <- data) {
      val z = 0.0
      for (i <- 0 until inputDim) {
        z += t(i) * weights(i)(h.size)
      }
      h = h :+ scala.math.tanh(z + biases(h.size))
      predictions(t.length - 1) = h(h.length - 1)
    }
    return predictions
  }
}
