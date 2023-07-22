import numpy as np

class SVM(object):

  def __init__(self, C=1.0, kernel='linear'):
    self.C = C
    self.kernel = kernel

  def fit(self, X, y):
    self.X = X
    self.y = y
    self.w = np.zeros(X.shape[1])
    self.b = 0.0

    for i in range(len(X)):
      if y[i] * np.dot(self.w, X[i]) + self.b <= 1:
        self.w += self.C * y[i] * X[i]
        self.b += self.C * y[i]

  def predict(self, X):
    scores = np.dot(X, self.w) + self.b
    return np.sign(scores)

