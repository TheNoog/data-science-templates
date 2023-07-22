import breeze.linalg._

class SVM(val C: Double, val kernel: String) {

  private val w = DenseVector(2)
  private var b = 0.0

  def fit(X: DenseMatrix[Double], y: DenseVector[Int], n: Int) {
    for (i <- 0 until n) {
      val score = w dot X(i) + b
      if (y(i) * score <= 1.0) {
        for (j <- 0 until 2) {
          w(j) += C * y(i) * X(i)(j)
        }
        b += C * y(i)
      }
    }
  }

  def predict(X: DenseVector[Double]) = {
    val score = w dot X + b
    score >= 0.0 ? 1 : -1
  }
}

object SVM {

  def main(args: Array[String]): Unit = {
    val svm = new SVM(1.0, "linear")
    svm.fit(DenseMatrix([[1, 2], [3, 4]], 2, 2), DenseVector([1, -1]), 2)
    println(svm.predict(DenseVector([5, 6]))) // prints 1
  }
}
