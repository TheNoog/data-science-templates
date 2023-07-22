#include <stdlib.h>
#include <stdio.h>

struct SVM {
  double *w;
  double b;
  int C;
  char *kernel;
};

struct SVM *SVM_new(int C, char *kernel) {
  struct SVM *svm = malloc(sizeof(struct SVM));
  svm->w = malloc(sizeof(double) * 2);
  svm->b = 0.0;
  svm->C = C;
  svm->kernel = kernel;
  return svm;
}

void SVM_fit(struct SVM *svm, double *X, int *y, int n) {
  for (int i = 0; i < n; i++) {
    double score = 0.0;
    for (int j = 0; j < 2; j++) {
      score += svm->w[j] * X[i * 2 + j];
    }
    if (y[i] * score + svm->b <= 1.0) {
      for (int j = 0; j < 2; j++) {
        svm->w[j] += svm->C * y[i] * X[i * 2 + j];
      }
      svm->b += svm->C * y[i];
    }
  }
}

int SVM_predict(struct SVM *svm, double *X) {
  double score = 0.0;
  for (int j = 0; j < 2; j++) {
    score += svm->w[j] * X[j];
  }
  return score >= 0.0 ? 1 : -1;
}

void SVM_free(struct SVM *svm) {
  free(svm->w);
  free(svm);
}
