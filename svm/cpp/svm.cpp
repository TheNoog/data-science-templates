#include <iostream>
#include <vector>

using namespace std;

class SVM {
 public:
  SVM(int C, char *kernel) {
    this->C = C;
    this->kernel = kernel;
    this->w = new vector<double>(2);
    this->b = 0.0;
  }

  void fit(vector<double> *X, vector<int> *y, int n) {
    for (int i = 0; i < n; i++) {
      double score = 0.0;
      for (int j = 0; j < 2; j++) {
        score += this->w[j] * X[i][j];
      }
      if (y[i] * score + this->b <= 1.0) {
        for (int j = 0; j < 2; j++) {
          this->w[j] += this->C * y[i] * X[i][j];
        }
        this->b += this->C * y[i];
      }
    }
  }

  int predict(vector<double> *X) {
    double score = 0.0;
    for (int j = 0; j < 2; j++) {
      score += this->w[j] * X[j];
    }
    return score >= 0.0 ? 1 : -1;
  }

  ~SVM() {
    delete this->w;
  }

 private:
  int C;
  char *kernel;
  vector<double> *w;
  double b;
};
