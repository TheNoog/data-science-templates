defmodule SVM do
  use LinearAlgebra

  @doc """
  Creates a new SVM object.

  ## Arguments

  * `C`: The hyperparameter C that controls the trade-off between the training error and the regularization term.
  * `kernel`: The kernel function that is used to map the data into a higher-dimensional space.

  ## Returns

  A new `SVM` object.
  """
  def new(c, kernel) do
    %SVM{
      C: c,
      kernel: kernel,
      w: [],
      b: 0.0
    }
  end

  @doc """
  Trains the SVM model on the given data.

  ## Arguments

  * `X`: A matrix of training data.
  * `y`: A vector of training labels.
  * `n`: The number of training examples.

  ## Returns

  The `SVM` object.
  """
  def fit(self, X, y, n) do
    self.w = []
    for i in 0..n - 1 do
      score = 0.0
      for j in 0..2 - 1 do
        score += self.w[j] * X[i][j]
      end
      if y[i] * score + self.b <= 1.0 do
        for j in 0..2 - 1 do
          self.w[j] += self.C * y[i] * X[i][j]
        end
        self.b += self.C * y[i]
      end
    end
    self
  end

  @doc """
  Makes predictions on the given data.

  ## Arguments

  * `X`: A matrix of test data.

  ## Returns

  A vector of predictions.
  """
  def predict(self, X) do
    y = []
    for x in X do
      score = 0.0
      for j in 0..2 - 1 do
        score += self.w[j] * x[j]
      end
      y = y ++ [score >= 0.0 ? 1 : -1]
    end
    y
  end
end
