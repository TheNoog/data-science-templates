import java.util.Arrays;

public class PCA {
  public static double[] pca(double[] data, int n) {
    // Standardize the data.
    double[] mean = Arrays.copyOf(data, n);
    double[] std = new double[n];
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < n; j++) {
        mean[j] += data[i * n + j];
      }
    }
    for (int j = 0; j < n; j++) {
      mean[j] /= data.length;
      std[j] = 0;
      for (int i = 0; i < data.length; i++) {
        std[j] += (data[i * n + j] - mean[j]) * (data[i * n + j] - mean[j]);
      }
      std[j] = Math.sqrt(std[j] / data.length);
      if (std[j] != 0) {
        for (int i = 0; i < data.length; i++) {
          data[i * n + j] /= std[j];
        }
      }
    }

    // Calculate the covariance matrix.
    double[][] covarianceMatrix = new double[n][n];
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data.length; j++) {
        for (int k = 0; k < n; k++) {
          covarianceMatrix[k][k] += data[i * n + k] * data[j * n + k];
        }
        covarianceMatrix[k][k] /= data.length - 1;
      }
    }

    // Calculate the eigenvalues and eigenvectors of the covariance matrix.
    double[] eigenvalues = new double[n];
    double[][] eigenvectors = new double[n][n];
    for (int i = 0; i < n; i++) {
      eigenvalues[i] = 0;
      eigenvectors[i][i] = 1;
      for (int j = 0; j < i; j++) {
        double sum = 0;
        for (int k = 0; k < n; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][i] -= 2 * sum * eigenvectors[j][j];
      }
      eigenvectors[i][i] = Math.sqrt(eigenvectors[i][i]);
      for (int j = i + 1; j < n; j++) {
        double sum = 0;
        for (int k = 0; k < n; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][j] = sum;
      }
    }

    // Sort the eigenvalues and eigenvectors in descending order.
    for (int i = 0; i < n - 1; i++) {
      for (int j = i + 1; j < n; j++) {
        if (eigenvalues[i] < eigenvalues[j]) {
          double tempEigenvalue = eigenvalues[i];
          eigenvalues[i] = eigenvalues[j];
          eigenvalues[j] = tempEigenvalue;
          for (int k = 0; k < n; k++) {
            double tempEigenvector = eigenvectors[i][k];
            eigenvectors[i][k] = eigenvectors[j][k];
            eigenvectors[j][k] = tempEigenvector;
          }
        }
      }
    }

    // Return the principal components.
    return eigenvectors[0:n];
  }

  public static void main(String[] args) {
    double[] data = {1, 2, 3, 4, 5};
    double[] principalComponents = pca(data, data.length);
    System.out.println(Arrays.toString(principalComponents));
  }
}
