#include <iostream>
#include <stdlib.h>
#include <math.h>

#define NUM_TREES 10
#define NUM_FEATURES 5

using namespace std;

struct DataPoint {
  int label;
  float features[NUM_FEATURES];
};

DataPoint *data = NULL;
int num_data_points = 0;

void load_data() {
  FILE *fp = fopen("data.csv", "r");
  if (fp == NULL) {
    cout << "Error opening data file." << endl;
    exit(1);
  }

  num_data_points = 0;
  while (1) {
    DataPoint *dp = new DataPoint();
    int i;
    for (i = 0; i < NUM_FEATURES; i++) {
      fscanf(fp, "%f,", &dp->features[i]);
    }
    fscanf(fp, "%d\n", &dp->label);

    num_data_points++;
    if (feof(fp)) {
      break;
    }

    data = realloc(data, sizeof(DataPoint) * num_data_points);
    data[num_data_points - 1] = *dp;
  }

  fclose(fp);
}

void free_data() {
  if (data != NULL) {
    for (int i = 0; i < num_data_points; i++) {
      delete data[i];
    }

    free(data);
    data = NULL;
  }
}

int main() {
  load_data();

  // Create a random forest with 10 trees.
  int *tree_labels = new int[NUM_TREES];
  for (int i = 0; i < NUM_TREES; i++) {
    tree_labels[i] = rand() % 2;
  }

  // Classify each data point using the random forest.
  int *predictions = new int[num_data_points];
  for (int i = 0; i < num_data_points; i++) {
    int correct_label = data[i].label;
    int prediction = 0;
    for (int j = 0; j < NUM_TREES; j++) {
      if (tree_labels[j] == data[i].label) {
        prediction++;
      }
    }

    predictions[i] = prediction > NUM_TREES / 2 ? 1 : 0;
  }

  // Calculate the accuracy of the random forest.
  int correct = 0;
  for (int i = 0; i < num_data_points; i++) {
    if (predictions[i] == data[i].label) {
      correct++;
    }
  }

  float accuracy = (float)correct / num_data_points;
  cout << "Accuracy: " << accuracy * 100 << "%" << endl;

  free_data();
  delete[] tree_labels;
  delete[] predictions;

  return 0;
}