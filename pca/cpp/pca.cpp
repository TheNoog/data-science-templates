#include <iostream>
#include <vector>

using namespace std;

void pca(vector<vector<float>> data, vector<vector<float>> &principal_components) {
  // Standardize the data.
  vector<float> mean(data[0].size());
  vector<float> std(data[0].size());
  for (int i = 0; i < data.size(); i++) {
    for (int j = 0; j < data[0].size(); j++) {
      mean[j] += data[i][j];
    }
  }
  for (int j = 0; j < data[0].size(); j++) {
    mean[j] /= data.size();
  }
  for (int i = 0; i < data.size(); i++) {
    for (int j = 0; j < data[0].size(); j++) {
      data[i][j] -= mean[j];
    }
  }
  for (int j = 0; j < data[0].size(); j++) {
    float sum = 0;
    for (int i = 0; i < data.size(); i++) {
      sum += pow(data[i][j], 2);
    }
    std[j] = sqrt(sum / data.size());
    if (std[j] != 0) {
      for (int i = 0; i < data.size(); i++) {
        data[i][j] /= std[j];
      }
    }
  }

  // Calculate the covariance matrix.
  vector<vector<float>> covariance_matrix(data[0].size(), vector<float>(data[0].size()));
  for (int i = 0; i < data.size(); i++) {
    for (int j = 0; j < data.size(); j++) {
      for (int k = 0; k < data[0].size(); k++) {
        covariance_matrix[k][k] += data[i][k] * data[j][k];
      }
      covariance_matrix[k][k] /= data.size() - 1;
    }
  }

  // Calculate the eigenvalues and eigenvectors of the covariance matrix.
  vector<float> eigenvalues(data[0].size());
  vector<vector<float>> eigenvectors(data[0].size(), vector<float>(data[0].size()));
  for (int i = 0; i < data[0].size(); i++) {
    eigenvalues[i] = 0;
    eigenvectors[i][i] = 1;
    for (int j = 0; j < i; j++) {
      float sum = 0;
      for (int k = 0; k < data[0].size(); k++) {
        sum += eigenvectors[i][k] * eigenvectors[j][k] * covariance_matrix[k][k];
      }
      eigenvectors[i][i] -= 2 * sum * eigenvectors[j][j];
    }
    eigenvectors[i][i] = sqrt(eigenvectors[i][i]);
    for (int j = i + 1; j < data[0].size(); j++) {
      float sum = 0;
      for (int k = 0; k < data[0].size(); k++) {
        sum += eigenvectors[i][k] * eigenvectors[j][k] * covariance_matrix[k][k];
      }
      eigenvectors[i][j] = sum;
    }
  }

  // Sort the eigenvalues and eigenvectors in descending order.
  for (int i = 0; i < data[0].size() - 1; i++) {
    for (int j = i + 1; j < data[0].size(); j++) {
      if (eigenvalues[i] < eigenvalues[j]) {
        float temp_eigenvalue = eigenvalues[i];
        eigenvalues[i] = eigenvalues[j];
        eigenvalues[j] = temp_eigenvalue;
        for (int k = 0; k < data[0].size(); k++) {
          float temp_eigenvector = eigenvectors[i][k];
          eigenvectors[i
