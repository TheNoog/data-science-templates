object LinearRegression {
  // Function to calculate the mean
  def calculateMean(list: List[Double]): Double = list.sum / list.length.toDouble

  // Function to calculate the slope (beta1)
  def calculateSlope(x: List[Double], y: List[Double]): Double = {
    val meanX = calculateMean(x)
    val meanY = calculateMean(y)
    val numerator = x.zip(y).map { case (xi, yi) => (xi - meanX) * (yi - meanY) }.sum
    val denominator = x.map(xi => math.pow(xi - meanX, 2)).sum
    numerator / denominator
  }

  // Function to calculate the intercept (beta0)
  def calculateIntercept(x: List[Double], y: List[Double], slope: Double): Double = {
    val meanX = calculateMean(x)
    val meanY = calculateMean(y)
    meanY - slope * meanX
  }

  // Function to make predictions
  def predict(x: Double, slope: Double, intercept: Double): Double = slope * x + intercept

  def main(args: Array[String]): Unit = {
    val x = List(1.0, 2.0, 3.0, 4.0, 5.0)  // Input features
    val y = List(2.0, 4.0, 5.0, 4.0, 6.0)  // Target variable

    val slope = calculateSlope(x, y)
    val intercept = calculateIntercept(x, y, slope)

    val newX = List(6.0, 7.0)

    println("Input\tPredicted Output")
    newX.foreach { xVal =>
      val yPred = predict(xVal, slope, intercept)
      println(s"$xVal\t$yPred")
    }
  }
}
