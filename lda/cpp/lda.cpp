#include <iostream>

using namespace std;

void LDA(float *data, int n, int d, float *coef, float *means) {
  // Initialize the coef and means arrays.
  for (int i = 0; i < d; i++) {
    coef[i] = 0.0;
    means[i] = 0.0;
  }

  // Calculate the means of the two classes.
  for (int i = 0; i < n; i++) {
    if (data[i * d + d - 1] == 0) {
      means[0] += data[i * d];
    } else {
      means[1] += data[i * d];
    }
  }
  means[0] /= n / 2.0;
  means[1] /= n / 2.0;

  // Calculate the coef array.
  for (int i = 0; i < d; i++) {
    for (int j = 0; j < n; j++) {
      if (data[j * d + d - 1] == 0) {
        coef[i] += data[j * d] - means[0];
      } else {
        coef[i] += data[j * d] - means[1];
      }
    }
    coef[i] /= n / 2.0;
  }
}

int main() {
  // Initialize the data array.
  float data[] = {1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0};
  int n = 3;
  int d = 3;

  // Initialize the coef and means arrays.
  float coef[d];
  float means[d];

  // Calculate the coef and means arrays.
  LDA(data, n, d, coef, means);

  // Print the coef array.
  for (int i = 0; i < d; i++) {
    cout << coef[i] << endl;
  }

  // Print the means array.
  for (int i = 0; i < d; i++) {
    cout << means[i] << endl;
  }

  return 0;
}
