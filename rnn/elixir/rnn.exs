defmodule RNN do
  use LinearAlgebra

  @doc """
  Creates a new RNN model with the given parameters.

  ## Parameters

  * `input_dim`: The number of features in the input data.
  * `hidden_dim`: The number of neurons in the hidden layer.
  * `output_dim`: The number of features in the output data.

  ## Returns

  A new `RNN` model.
  """
  def new(input_dim, hidden_dim, output_dim) do
    Weights = Vector.fill(input_dim, fn _ -> Vector.fill(hidden_dim, rand()) end)
    Biases = Vector.fill(hidden_dim, rand())
    h = Vector.fill(hidden_dim, 0.0)
    {Weights, Biases, h}
  end

  @doc """
  Trains the RNN model on the given data.

  ## Parameters

  * `data`: The training data.

  ## Returns

  The trained RNN model.
  """
  def train(model, data) do
    for sequence in data do
      for t in sequence do
        z = Weights * t + Biases
        h = tanh(z)
      end
    end
    model
  end

  @doc """
  Makes predictions on the given data.

  ## Parameters

  * `data`: The data to make predictions on.

  ## Returns

  The predictions for the given data.
  """
  def predict(model, data) do
    for sequence in data do
      z = Weights * sequence + Biases
      predictions = tanh(z)
    end
    predictions
  end
end
