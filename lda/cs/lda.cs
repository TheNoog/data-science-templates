using System;

public class LDA {
  public static void LDA(float[] data, int n, int d, float[] coef, float[] means) {
    // Initialize the coef and means arrays.
    for (int i = 0; i < d; i++) {
      coef[i] = 0.0f;
      means[i] = 0.0f;
    }

    // Calculate the means of the two classes.
    for (int i = 0; i < n; i++) {
      if (data[i * d + d - 1] == 0) {
        means[0] += data[i * d];
      } else {
        means[1] += data[i * d];
      }
    }
    means[0] /= n / 2.0f;
    means[1] /= n / 2.0f;

    // Calculate the coef array.
    for (int i = 0; i < d; i++) {
      for (int j = 0; j < n; j++) {
        if (data[j * d + d - 1] == 0) {
          coef[i] += data[j * d] - means[0];
        } else {
          coef[i] += data[j * d] - means[1];
        }
      }
      coef[i] /= n / 2.0f;
    }
  }

  public static void Main(string[] args) {
    // Initialize the data array.
    float[] data = new float[] {1.0f, 2.0f, 0.0f, 3.0f, 4.0f, 5.0f, 1.0f, 2.0f, 1.0f};
    int n = 3;
    int d = 3;

    // Initialize the coef and means arrays.
    float[] coef = new float[d];
    float[] means = new float[d];

    // Calculate the coef and means arrays.
    LDA(data, n, d, coef, means);

    // Print the coef array.
    for (int i = 0; i < d; i++) {
      Console.WriteLine(coef[i]);
    }

    // Print the means array.
    for (int i = 0; i < d; i++) {
      Console.WriteLine(means[i]);
    }
  }
}
