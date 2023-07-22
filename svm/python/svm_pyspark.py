import numpy as np
from pyspark.ml.classification import SVM

class SVM(object):

  def __init__(self, C=1.0, kernel='linear'):
    self.C = C
    self.kernel = kernel

  def fit(self, X, y):
    model = SVM(C=self.C, kernel=self.kernel)
    model.fit(X, y)
    self.w = model.coefficients
    self.b = model.intercept

  def predict(self, X):
    predictions = model.predict(X)
    return predictions

