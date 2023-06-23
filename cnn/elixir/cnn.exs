defmodule HiddenLayer do
  defstruct weights: [], bias: []

  def initialize_weights(hidden_size, input_size) do
    random = :random.uniform()
    
    weights = for _ <- 1..hidden_size, do: for _ <- 1..input_size, do: random.() - 0.5
    bias = for _ <- 1..hidden_size, do: random.() - 0.5

    %HiddenLayer{weights: weights, bias: bias}
  end
end

defmodule OutputLayer do
  defstruct weights: [], bias: []

  def initialize_weights(output_size, hidden_size) do
    random = :random.uniform()

    weights = for _ <- 1..output_size, do: for _ <- 1..hidden_size, do: random.() - 0.5
    bias = for _ <- 1..output_size, do: random.() - 0.5

    %OutputLayer{weights: weights, bias: bias}
  end
end

defmodule ConvolutionalNeuralNetwork do
  alias HiddenLayer
  alias OutputLayer

  @input_size 64
  @hidden_size 128
  @output_size 10
  @learning_rate 0.01
  @epochs 10

  def sigmoid(x), do: 1.0 / (1.0 + :math.exp(-x))

  def forward_propagation(input, hidden_layer, output_layer) do
    hidden_output = Enum.map(hidden_layer.bias, fn _ -> 0.0 end)

    Enum.each(0..@hidden_size-1, fn i ->
      sum = hidden_layer.bias[i]

      Enum.each(0..@input_size-1, fn j ->
        sum = sum + input[j] * hidden_layer.weights[i][j]
      end)

      hidden_output[i] = sigmoid(sum)
    end)

    output = Enum.map(output_layer.bias, fn _ -> 0.0 end)

    Enum.each(0..@output_size-1, fn i ->
      sum = output_layer.bias[i]

      Enum.each(0..@hidden_size-1, fn j ->
        sum = sum + hidden_output[j] * output_layer.weights[i][j]
      end)

      output[i] = sigmoid(sum)
    end)

    output
  end

  def back_propagation(input, target, hidden_layer, output_layer) do
    hidden_output = Enum.map(hidden_layer.bias, fn _ -> 0.0 end)
    output = forward_propagation(input, hidden_layer, output_layer)

    output_delta = Enum.map(output, fn o -> (o - target) * o * (1 - o) end)
    hidden_delta = Enum.map(hidden_output, fn _ -> 0.0 end)

    Enum.each(0..@hidden_size-1, fn i ->
      error = Enum.reduce(0..@output_size-1, fn j, acc ->
        acc + output_layer.weights[j][i] * output_delta[j]
      end)

      hidden_delta[i] = error * hidden_output[i] * (1 - hidden_output[i])
    end)

    Enum.each(0..@output_size-1, fn i ->
      Enum.each(0..@hidden_size-1, fn j ->
        output_layer.weights[i][j] = output_layer.weights[i][j] - @learning_rate * output_delta[i] * hidden_output[j]
      end)

      output_layer.bias[i] = output_layer.bias[i] - @learning_rate * output_delta[i]
    end)

    Enum.each(0..@hidden_size-1, fn i ->
      Enum.each(0..@input_size-1, fn j ->
        hidden_layer.weights[i][j] = hidden_layer.weights[i][j] - @learning_rate * hidden_delta[i] * input[j]
      end)

      hidden_layer.bias[i] = hidden_layer.bias[i] - @learning_rate * hidden_delta[i]
    end)

    {hidden_layer, output_layer}
  end

  def main do
    input = [/* Input values here */]
    target = [/* Target values here */]

    hidden_layer = HiddenLayer.initialize_weights(@hidden_size, @input_size)
    output_layer = OutputLayer.initialize_weights(@output_size, @hidden_size)

    {hidden_layer, output_layer} =
      Enum.reduce(1..@epochs, {hidden_layer, output_layer}, fn _epoch, {h_layer, o_layer} ->
        back_propagation(input, target, h_layer, o_layer)
      end)

    output = forward_propagation(input, hidden_layer, output_layer)

    IO.puts("Output: #{inspect(output)}")
  end
end

ConvolutionalNeuralNetwork.main()
