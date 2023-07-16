import scala.util.Random

object LassoRegression {

  // Define the number of samples and features
  val N_SAMPLES: Int = 100
  val N_FEATURES: Int = 20

  // Function to calculate the mean squared error
  def calculateMeanSquaredError(yTrue: Array[Double], yPred: Array[Double]): Double = {
    val n = yTrue.length
    val squaredErrors = yTrue.zip(yPred).map { case (y, yPred) => math.pow(y - yPred, 2) }
    squaredErrors.sum / n.toDouble
  }

  // Function to perform LASSO regression
  def lassoRegression(X: Array[Array[Double]], y: Array[Double], alpha: Double): Array[Double] = {
    // Maximum number of iterations for coordinate descent
    val maxIterations: Int = 100

    // Step size for coordinate descent
    val stepSize: Double = 0.01

    val nSamples: Int = X.length
    val nFeatures: Int = X(0).length

    // Initialize the coefficients to zero
    var coefficients: Array[Double] = Array.fill(nFeatures)(0.0)

    // Perform coordinate descent
    for (_ <- 1 to maxIterations) {
      for (j <- 0 until nFeatures) {
        // Calculate the gradient for feature j
        var gradient: Double = 0.0
        for (i <- 0 until nSamples) {
          var pred: Double = 0.0
          for (k <- 0 until nFeatures) {
            if (k != j) {
              pred += X(i)(k) * coefficients(k)
            }
          }
          gradient += (y(i) - pred) * X(i)(j)
        }

        // Update the coefficient using LASSO penalty
        if (gradient > alpha) {
          coefficients(j) = (gradient - alpha) * stepSize
        } else if (gradient < -alpha) {
          coefficients(j) = (gradient + alpha) * stepSize
        } else {
          coefficients(j) = 0.0
        }
      }
    }

    coefficients
  }

  // Generate some synthetic data
  def generateSyntheticData(): (Array[Array[Double]], Array[Double]) = {
    val X = Array.fill(N_SAMPLES, N_FEATURES)(Random.nextDouble())
    val y = Array.tabulate(N_SAMPLES) { i =>
      X(i).zipWithIndex.map { case (x, j) => x * (j + 1) }.sum + 0.1 * Random.nextDouble()
    }
    (X, y)
  }

  // Main function
  def main(args: Array[String]): Unit = {
    // Generate some synthetic data
    val (X, y) = generateSyntheticData()

    // Split the data into training and test sets
    val nTrainSamples: Int = (N_SAMPLES * 0.8).toInt
    val nTestSamples: Int = N_SAMPLES - nTrainSamples
    val XTrain: Array[Array[Double]] = X.take(nTrainSamples)
    val yTrain: Array[Double] = y.take(nTrainSamples)
    val XTest: Array[Array[Double]] = X.drop(nTrainSamples)
    val yTest: Array[Double] = y.drop(nTrainSamples)

    // Perform LASSO regression
    val alpha: Double = 0.1
    val coefficients: Array[Double] = lassoRegression(XTrain, yTrain, alpha)

    // Make predictions on the test set
    val yPred: Array[Double] = XTest.map(sample => sample.zip(coefficients).map { case (x, c) => x * c }.sum)

    // Calculate the mean squared error
    val mse: Double = calculateMeanSquaredError(yTest, yPred)
    println("Mean Squared Error: " + mse)

    // Print the true coefficients and the estimated coefficients
    print("True Coefficients: [1.0 ")
    for (i <- 1 until N_FEATURES) {
      print((i + 1) + " ")
    }
    println("]")

    println("Estimated Coefficients: " + coefficients.mkString(" "))
  }
}

LassoRegression.main(Array())
