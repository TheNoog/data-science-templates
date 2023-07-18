def lda(data: Array[Double], n: Int, d: Int): Array[Double] = {
  // Initialize the coef and means arrays.
  val coef = Array.fill(d)(0.0)
  val means = Array.fill(d)(0.0)

  // Calculate the means of the two classes.
  for (i <- 0 until n) {
    if (data(i * d) == 0.0) {
      means(0) += data(i * d)
    } else {
      means(1) += data(i * d)
    }
  }
  means(0) /= n / 2.0
  means(1) /= n / 2.0

  // Calculate the coef array.
  for (i <- 0 until d) {
    for (j <- 0 until n) {
      if (data(j * d) == 0.0) {
        coef(i) += data(j * d) - means(0)
      } else {
        coef(i) += data(j * d) - means(1)
      }
    }
    coef(i) /= n / 2.0
  }

  coef
}

object LDA {
  def main(args: Array[String]): Unit = {
    // Initialize the data array.
    val data = Array(1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0)
    val n = 3
    val d = 3

    // Calculate the coef array.
    val coef = lda(data, n, d)

    // Print the coef array.
    for (coefValue <- coef) {
      println(coefValue)
    }
  }
}
