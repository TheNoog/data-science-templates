#include <iostream>
#include <vector>

using namespace std;

class LogisticRegression {
  public:
    LogisticRegression(int feature_count) {
      weights = vector<double>(feature_count, 0.0);
      bias = 0.0;
    }

    void train(const vector<double>& features, int label) {
      double prediction = sigmoid(dot(features, weights) + bias);
      double error = label - prediction;

      for (int i = 0; i < feature_count; i++) {
        weights[i] += error * features[i];
      }
      bias += error;
    }

    int predict(const vector<double>& features) {
      double prediction = sigmoid(dot(features, weights) + bias);
      if (prediction > 0.5) {
        return 1;
      } else {
        return 0;
      }
    }

  private:
    vector<double> weights;
    double bias;

    double sigmoid(double x) {
      return 1.0 / (1.0 + exp(-x));
    }

    double dot(const vector<double>& x, const vector<double>& y) {
      double sum = 0.0;
      for (int i = 0; i < x.size(); i++) {
        sum += x[i] * y[i];
      }
      return sum;
    }
};

int main() {
  // Initialize the data
  vector<double> features = {1.0, 2.0};
  int label = 1;

  // Create the logistic regression model
  LogisticRegression model(2);

  // Train the model
  for (int i = 0; i < 100; i++) {
    model.train(features, label);
  }

  // Predict the label for a new data point
  vector<double> new_features = {3.0, 4.0};
  int new_label = model.predict(new_features);

  // Print the prediction
  cout << "The predicted label is " << new_label << endl;

  return 0;
}
