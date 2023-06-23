defmodule NeuralNetwork do
  defstruct weights1: [], weights2: [], biases1: [], biases2: [], learning_rate: 0.0

  def sigmoid(x), do: 1.0 / (1.0 + :math.exp(-x))

  def sigmoid_derivative(x), do: sigmoid(x) * (1.0 - sigmoid(x))

  def train(network = %NeuralNetwork{}, x, y, epochs) do
    for _ <- 1..epochs do
      {hidden_layer, output_layer} = forward_pass(network, x)

      output_error = output_layer - y
      output_delta = output_error * sigmoid_derivative(output_layer)

      hidden_error = output_delta * Matrix.transpose(network.weights2)
      hidden_delta = hidden_error * sigmoid_derivative(hidden_layer)

      network = update_weights_biases(network, x, hidden_layer, hidden_delta, output_delta)
    end

    network
  end

  def forward_pass(network = %NeuralNetwork{}, x) do
    hidden_layer = sigmoid(Matrix.multiply(x, network.weights1) + network.biases1)
    output_layer = sigmoid(Matrix.multiply(hidden_layer, network.weights2) + network.biases2)

    {hidden_layer, output_layer}
  end

  def update_weights_biases(network = %NeuralNetwork{}, x, hidden_layer, hidden_delta, output_delta) do
    network.weights2 = network.weights2 - network.learning_rate * Matrix.transpose(hidden_layer) * output_delta
    network.biases2 = network.biases2 - network.learning_rate * Enum.sum(output_delta)
    network.weights1 = network.weights1 - network.learning_rate * Matrix.transpose(x) * hidden_delta
    network.biases1 = network.biases1 - network.learning_rate * Enum.sum(hidden_delta)

    network
  end

  def predict(network = %NeuralNetwork{}, x) do
    {_, output_layer} = forward_pass(network, x)
    output_layer
  end
end

# Example dataset
x = Matrix.new([[0, 0], [0, 1], [1, 0], [1, 1]])
y = Matrix.new([[0], [1], [1], [0]])

# Create and train the neural network
network = %NeuralNetwork{
  weights1: Matrix.random(2, 4),
  weights2: Matrix.random(4, 1),
  biases1: Matrix.random(4, 1),
  biases2: Matrix.random(1, 1),
  learning_rate: 0.1
}

epochs = 1000
network = NeuralNetwork.train(network, x, y, epochs)

# Make predictions on new data
predictions = NeuralNetwork.predict(network, x)

# Print the predictions
Enum.each(predictions, fn prediction ->
  IO.puts("Predicted Output: #{prediction}")
end)
