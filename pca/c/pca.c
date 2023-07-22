#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void pca(float *data, int n, int d, float *principal_components) {
  // Standardize the data.
  float *mean = (float *)malloc(d * sizeof(float));
  float *std = (float *)malloc(d * sizeof(float));
  for (int i = 0; i < d; i++) {
    mean[i] = 0;
    std[i] = 0;
    for (int j = 0; j < n; j++) {
      mean[i] += data[i + j * d];
    }
    mean[i] /= n;
    for (int j = 0; j < n; j++) {
      std[i] += pow(data[i + j * d] - mean[i], 2);
    }
    std[i] = sqrt(std[i] / n);
    for (int j = 0; j < n; j++) {
      data[i + j * d] -= mean[i];
      if (std[i] != 0) {
        data[i + j * d] /= std[i];
      }
    }
  }

  // Calculate the covariance matrix.
  float *covariance_matrix = (float *)malloc(d * d * sizeof(float));
  for (int i = 0; i < d; i++) {
    for (int j = 0; j < d; j++) {
      covariance_matrix[i + j * d] = 0;
      for (int k = 0; k < n; k++) {
        covariance_matrix[i + j * d] += data[i + k * d] * data[j + k * d];
      }
      covariance_matrix[i + j * d] /= n - 1;
    }
  }

  // Calculate the eigenvalues and eigenvectors of the covariance matrix.
  float *eigenvalues = (float *)malloc(d * sizeof(float));
  float *eigenvectors = (float *)malloc(d * d * sizeof(float));
  for (int i = 0; i < d; i++) {
    eigenvalues[i] = 0;
    eigenvectors[i + i * d] = 1;
    for (int j = 0; j < i; j++) {
      float sum = 0;
      for (int k = 0; k < d; k++) {
        sum += eigenvectors[i + k * d] * eigenvectors[j + k * d] * covariance_matrix[k + k * d];
      }
      eigenvectors[i + i * d] -= 2 * sum * eigenvectors[j + j * d];
    }
    eigenvectors[i + i * d] = sqrt(eigenvectors[i + i * d]);
    for (int j = i + 1; j < d; j++) {
      float sum = 0;
      for (int k = 0; k < d; k++) {
        sum += eigenvectors[i + k * d] * eigenvectors[j + k * d] * covariance_matrix[k + k * d];
      }
      eigenvectors[i + j * d] = sum;
    }
  }

  // Sort the eigenvalues and eigenvectors in descending order.
  for (int i = 0; i < d - 1; i++) {
    for (int j = i + 1; j < d; j++) {
      if (eigenvalues[i] < eigenvalues[j]) {
        float temp_eigenvalue = eigenvalues[i];
        eigenvalues[i] = eigenvalues[j];
        eigenvalues[j] = temp_eigenvalue;
        for (int k = 0; k < d; k++) {
          float temp_eigenvector = eigenvectors[i + k * d];
          eigenvectors[i + k * d] = eigenvectors[j + k * d];
          eigenvectors[j + k * d] = temp_eigenvector;
        }
      }
    }
  }

  // Copy the principal components to the output array.
  for (int i = 0; i < d
