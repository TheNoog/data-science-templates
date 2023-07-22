defmodule LogisticRegression do
  defstruct weights: [], bias: 0.0

  @doc """
  Trains the logistic regression model on the given data point.

  ## Parameters

  * `features` - The features of the data point.
  * `label` - The label of the data point.

  ## Returns

  None if the model is not initialized, otherwise the model.
  """
  def train(self, features, label) do
    if not self.weights do
      raise ArgumentError, "Model is not initialized"
    end

    prediction = sigmoid(dot(features, self.weights) + self.bias)
    error = label - prediction

    self.weights =
      for i <- 0..length(features) - 1,
        do: self.weights[i] + error * features[i]
    self.bias += error

    self
  end

  @doc """
  Predicts the label for the given data point.

  ## Parameters

  * `features` - The features of the data point.

  ## Returns

  The predicted label.
  """
  def predict(self, features) do
    if not self.weights do
      raise ArgumentError, "Model is not initialized"
    end

    sigmoid(dot(features, self.weights) + self.bias) > 0.5
  end

  defp sigmoid(x) do
    1.0 / (1.0 + exp(-x))
  end

  defp dot(features, weights) do
    sum = 0.0
    for i <- 0..length(features) - 1,
      do: sum + features[i] * weights[i]
    sum
  end
end

defmodule Main do
  def main() do
    # Initialize the data
    features = [1.0, 2.0]
    label = 1

    # Create the logistic regression model
    model = LogisticRegression.new()

    # Train the model
    for i <- 0..100, do: model.train(features, label)

    # Predict the label for a new data point
    new_features = [3.0, 4.0]
    new_label = model.predict(new_features)

    # Print the prediction
    IO.puts("The predicted label is #{new_label}")
  end
end

