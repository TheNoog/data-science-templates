#include <stdio.h>
#include <stdlib.h>

#define FEATURE_COUNT 2
#define LABEL_COUNT 2

int main() {
  // Initialize the data
  double features[FEATURE_COUNT] = {1.0, 2.0};
  int label = 1;

  // Create the logistic regression model
  double weights[FEATURE_COUNT] = {0.0, 0.0};
  double bias = 0.0;

  // Train the model
  for (int i = 0; i < 100; i++) {
    double prediction = sigmoid(dot(features, weights) + bias);
    double error = label - prediction;

    for (int j = 0; j < FEATURE_COUNT; j++) {
      weights[j] += error * features[j];
    }
    bias += error;
  }

  // Predict the label for a new data point
  double new_features[FEATURE_COUNT] = {3.0, 4.0};
  double new_label = sigmoid(dot(new_features, weights) + bias);

  // Print the prediction
  printf("The predicted label is %d\n", new_label);

  return 0;
}

double sigmoid(double x) {
  return 1.0 / (1.0 + exp(-x));
}

double dot(double *x, double *y) {
  double sum = 0.0;
  for (int i = 0; i < FEATURE_COUNT; i++) {
    sum += x[i] * y[i];
  }
  return sum;
}
