fun pca(data: Array<Double>, n: Int): Array<Double> {
  // Standardize the data.
  val mean = Array(n) { 0.0 }
  val std = Array(n) { 0.0 }
  for (i in 0 until data.size) {
    for (j in 0 until n) {
      mean[j] += data[i * n + j]
    }
  }
  for (j in 0 until n) {
    mean[j] /= data.size
    std[j] = 0.0
    for (i in 0 until data.size) {
      std[j] += (data[i * n + j] - mean[j]) * (data[i * n + j] - mean[j])
    }
    std[j] = Math.sqrt(std[j] / data.size)
    if (std[j] > 0.0) {
      for (i in 0 until data.size) {
        data[i * n + j] /= std[j]
      }
    }
  }

  // Calculate the covariance matrix.
  val covarianceMatrix = Array(n) { DoubleArray(n) }
  for (i in 0 until data.size) {
    for (j in 0 until data.size) {
      for (k in 0 until n) {
        covarianceMatrix[k][k] += data[i * n + k] * data[j * n + k]
      }
      covarianceMatrix[k][k] /= data.size - 1
    }
  }

  // Calculate the eigenvalues and eigenvectors of the covariance matrix.
  val eigenvalues = DoubleArray(n)
  val eigenvectors = DoubleArray(n) { DoubleArray(n) }
  for (i in 0 until n) {
    eigenvalues[i] = 0.0
    eigenvectors[i] = DoubleArray(n) { 1.0 }
    for (j in 0 until i) {
      val sum = 0.0
      for (k in 0 until n) {
        sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k]
      }
      eigenvectors[i][i] -= 2.0 * sum * eigenvectors[j][j]
    }
    eigenvectors[i][i] = Math.sqrt(eigenvectors[i][i])
    for (j in i + 1 until n) {
      val sum = 0.0
      for (k in 0 until n) {
        sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k]
      }
      eigenvectors[i][j] = sum
    }
  }

  // Sort the eigenvalues and eigenvectors in descending order.
  for (i in 0 until n - 1) {
    for (j in i + 1 until n) {
      if (eigenvalues[i] < eigenvalues[j]) {
        val tempEigenvalue = eigenvalues[i]
        eigenvalues[i] = eigenvalues[j]
        eigenvalues[j] = tempEigenvalue
        for (k in 0 until n) {
          val tempEigenvector = eigenvectors[i][k]
          eigenvectors[i][k] = eigenvectors[j][k]
          eigenvectors[j][k] = tempEigenvector
        }
      }
    }
  }

  // Return the principal components.
  return eigenvectors.slice(0, n)
}

fun main(args: Array<String>) {
  val data = arrayOf(1.0, 2.0, 3.0, 4.0, 5.0)
  val principalComponents = pca(data, data.size)
  println(principalComponents.contentToString())
}
