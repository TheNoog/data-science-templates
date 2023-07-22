function pca(data, n) {
    // Standardize the data.
    let mean = new Array(n);
    let std = new Array(n);
    for (let i = 0; i < data.length; i++) {
      for (let j = 0; j < n; j++) {
        mean[j] += data[i * n + j];
      }
    }
    for (let j = 0; j < n; j++) {
      mean[j] /= data.length;
      std[j] = 0;
      for (let i = 0; i < data.length; i++) {
        std[j] += (data[i * n + j] - mean[j]) * (data[i * n + j] - mean[j]);
      }
      std[j] = Math.sqrt(std[j] / data.length);
      if (std[j] !== 0) {
        for (let i = 0; i < data.length; i++) {
          data[i * n + j] /= std[j];
        }
      }
    }
  
    // Calculate the covariance matrix.
    let covarianceMatrix = new Array(n);
    for (let i = 0; i < n; i++) {
      covarianceMatrix[i] = new Array(n);
    }
    for (let i = 0; i < data.length; i++) {
      for (let j = 0; j < data.length; j++) {
        for (let k = 0; k < n; k++) {
          covarianceMatrix[k][k] += data[i * n + k] * data[j * n + k];
        }
        covarianceMatrix[k][k] /= data.length - 1;
      }
    }
  
    // Calculate the eigenvalues and eigenvectors of the covariance matrix.
    let eigenvalues = new Array(n);
    let eigenvectors = new Array(n);
    for (let i = 0; i < n; i++) {
      eigenvalues[i] = 0;
      eigenvectors[i] = new Array(n);
      eigenvectors[i][i] = 1;
      for (let j = 0; j < i; j++) {
        let sum = 0;
        for (let k = 0; k < n; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][i] -= 2 * sum * eigenvectors[j][j];
      }
      eigenvectors[i][i] = Math.sqrt(eigenvectors[i][i]);
      for (let j = i + 1; j < n; j++) {
        let sum = 0;
        for (let k = 0; k < n; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][j] = sum;
      }
    }
  
    // Sort the eigenvalues and eigenvectors in descending order.
    for (let i = 0; i < n - 1; i++) {
      for (let j = i + 1; j < n; j++) {
        if (eigenvalues[i] < eigenvalues[j]) {
          let tempEigenvalue = eigenvalues[i];
          eigenvalues[i] = eigenvalues[j];
          eigenvalues[j] = tempEigenvalue;
          for (let k = 0; k < n; k++) {
            let tempEigenvector = eigenvectors[i][k];
            eigenvectors[i][k] = eigenvectors[j][k];
            eigenvectors[j][k] = tempEigenvector;
          }
        }
      }
    }
  
    // Return the principal components.
    return eigenvectors.slice(0, n);
  }
  
  console.log(pca([1, 2, 3, 4, 5], 5));
  