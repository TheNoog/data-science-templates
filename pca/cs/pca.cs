using System;
using System.Collections.Generic;
using System.Linq;

public class PCA {
  public static void PCA(float[][] data, float[][] principalComponents) {
    // Standardize the data.
    float[] mean = new float[data[0].Length];
    float[] std = new float[data[0].Length];
    for (int i = 0; i < data.Length; i++) {
      for (int j = 0; j < data[0].Length; j++) {
        mean[j] += data[i][j];
      }
    }
    for (int j = 0; j < data[0].Length; j++) {
      mean[j] /= data.Length;
    }
    for (int i = 0; i < data.Length; i++) {
      for (int j = 0; j < data[0].Length; j++) {
        data[i][j] -= mean[j];
      }
    }
    for (int j = 0; j < data[0].Length; j++) {
      float sum = 0;
      for (int i = 0; i < data.Length; i++) {
        sum += pow(data[i][j], 2);
      }
      std[j] = sqrt(sum / data.Length);
      if (std[j] != 0) {
        for (int i = 0; i < data.Length; i++) {
          data[i][j] /= std[j];
        }
      }
    }

    // Calculate the covariance matrix.
    float[][] covarianceMatrix = new float[data[0].Length][];
    for (int i = 0; i < data[0].Length; i++) {
      covarianceMatrix[i] = new float[data[0].Length];
      for (int j = 0; j < data[0].Length; j++) {
        covarianceMatrix[i][j] = 0;
        for (int k = 0; k < data.Length; k++) {
          covarianceMatrix[i][j] += data[k][i] * data[k][j];
        }
        covarianceMatrix[i][j] /= data.Length - 1;
      }
    }

    // Calculate the eigenvalues and eigenvectors of the covariance matrix.
    float[] eigenvalues = new float[data[0].Length];
    float[][] eigenvectors = new float[data[0].Length][];
    for (int i = 0; i < data[0].Length; i++) {
      eigenvalues[i] = 0;
      eigenvectors[i] = new float[data[0].Length];
      eigenvectors[i][i] = 1;
      for (int j = 0; j < i; j++) {
        float sum = 0;
        for (int k = 0; k < data[0].Length; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][i] -= 2 * sum * eigenvectors[j][j];
      }
      eigenvectors[i][i] = sqrt(eigenvectors[i][i]);
      for (int j = i + 1; j < data[0].Length; j++) {
        float sum = 0;
        for (int k = 0; k < data[0].Length; k++) {
          sum += eigenvectors[i][k] * eigenvectors[j][k] * covarianceMatrix[k][k];
        }
        eigenvectors[i][j] = sum;
      }
    }

    // Sort the eigenvalues and eigenvectors in descending order.
    for (int i = 0; i < data[0].Length - 1; i++) {
      for (int j = i + 1; j < data[0].Length; j++) {
        if (eigenvalues[i] < eigenvalues[j]) {
          float tempEigenvalue = eigenvalues[i];
          eigenvalues[i] = eigenvalues[j];
          eigenvalues[j] = tempEigenvalue;
          for (int k = 0; k < data[0].Length; k++) {
            float tempEigenvector =
