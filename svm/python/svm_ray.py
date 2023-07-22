import ray
from ray.tune.trainable import Trainable

class SVM(Trainable):

  def __init__(self, C=1.0, kernel='linear'):
    self.C = C
    self.kernel = kernel

  def train(self, X, y):
    from sklearn.svm import SVC
    model = SVC(C=self.C, kernel=self.kernel)
    model.fit(X, y)
    self.w = model.coef_
    self.b = model.intercept_

  def predict(self, X):
    return model.predict(X)

