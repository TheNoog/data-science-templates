package main

import (
  "fmt"
  "math"
)

func pca(data []float64, n int) []float64 {
  // Standardize the data.
  mean := make([]float64, n)
  var std float64
  for i := 0; i < len(data); i++ {
    for j := 0; j < n; j++ {
      mean[j] += data[i*n+j]
    }
  }
  for j := 0; j < n; j++ {
    mean[j] /= len(data)
    std = 0
    for i := 0; i < len(data); i++ {
      std += (data[i*n+j] - mean[j]) * (data[i*n+j] - mean[j])
    }
    std = math.Sqrt(std / len(data))
    if std != 0 {
      for i := 0; i < len(data); i++ {
        data[i*n+j] /= std
      }
    }
  }

  // Calculate the covariance matrix.
  covariance_matrix := make([]float64, n*n)
  for i := 0; i < len(data); i++ {
    for j := 0; j < len(data); j++ {
      for k := 0; k < n; k++ {
        covariance_matrix[i*n+k] += (data[i*n+k] - mean[k]) * (data[j*n+k] - mean[k])
      }
      covariance_matrix[j*n+i] = covariance_matrix[i*n+j]
    }
  }

  // Calculate the eigenvalues and eigenvectors of the covariance matrix.
  eigenvalues := make([]float64, n)
  eigenvectors := make([]float64, n*n)
  for i := 0; i < n; i++ {
    eigenvalues[i] = 0
    eigenvectors[i*n+i] = 1
    for j := 0; j < i; j++ {
      sum := 0
      for k := 0; k < n; k++ {
        sum += eigenvectors[i*n+k] * eigenvectors[j*n+k] * covariance_matrix[k*n+k]
      }
      eigenvectors[i*n+i] -= 2 * sum * eigenvectors[j*n+j]
    }
    eigenvectors[i*n+i] = math.Sqrt(eigenvectors[i*n+i])
    for j := i + 1; j < n; j++ {
      sum := 0
      for k := 0; k < n; k++ {
        sum += eigenvectors[i*n+k] * eigenvectors[j*n+k] * covariance_matrix[k*n+k]
      }
      eigenvectors[i*n+j] = sum
    }
  }

  // Sort the eigenvalues and eigenvectors in descending order.
  for i := 0; i < n - 1; i++ {
    for j := i + 1; j < n; j++ {
      if eigenvalues[i] < eigenvalues[j] {
        float64 temp_eigenvalue := eigenvalues[i]
        eigenvalues[i] = eigenvalues[j]
        eigenvalues[j] = temp_eigenvalue
        for k := 0; k < n; k++ {
          float64 temp_eigenvector := eigenvectors[i*n+k]
          eigenvectors[i*n+k] = eigenvectors[j*n+k]
          eigenvectors[j*n+k] = temp_eigenvector
        }
      }
    }
  }

  // Return the principal components.
  return eigenvectors[0:n]
}

func main() {
  data := []float64{1, 2, 3, 4, 5}
  principal_components := pca(data, len(data))
  fmt.Println(principal_components)
}
