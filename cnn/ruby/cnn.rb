class HiddenLayer
    attr_accessor :weights, :bias
  
    def initialize(hidden_size, input_size)
      @weights = Array.new(hidden_size) { Array.new(input_size) { rand - 0.5 } }
      @bias = Array.new(hidden_size) { rand - 0.5 }
    end
  end
  
  class OutputLayer
    attr_accessor :weights, :bias
  
    def initialize(output_size, hidden_size)
      @weights = Array.new(output_size) { Array.new(hidden_size) { rand - 0.5 } }
      @bias = Array.new(output_size) { rand - 0.5 }
    end
  end
  
  InputSize = 64
  HiddenSize = 128
  OutputSize = 10
  LearningRate = 0.01
  Epochs = 10
  
  def sigmoid(x)
    1.0 / (1.0 + Math.exp(-x))
  end
  
  def forward_propagation(input, hidden_layer, output_layer)
    hidden_output = hidden_layer.bias.zip(hidden_layer.weights).map do |b, w|
      sigmoid(b + dot_product(w, input))
    end
  
    output = output_layer.bias.zip(output_layer.weights).map do |b, w|
      sigmoid(b + dot_product(w, hidden_output))
    end
  
    output
  end
  
  def back_propagation(input, target, hidden_layer, output_layer)
    hidden_output = hidden_layer.bias.zip(hidden_layer.weights).map do |b, w|
      sigmoid(b + dot_product(w, input))
    end
    output = forward_propagation(input, hidden_layer, output_layer)
  
    output_delta = output.zip(target).map { |o, t| (o - t) * o * (1 - o) }
    hidden_delta = dot_product(output_layer.weights.transpose, output_delta).zip(hidden_output).map do |w, h|
      w * h * (1 - h)
    end
  
    output_layer.weights = matrix_subtraction(output_layer.weights,
                                              scalar_multiply(LearningRate, dot_product(matrix_transpose(output_delta), matrix_transpose(hidden_output))))
    output_layer.bias = vector_subtraction(output_layer.bias,
                                           scalar_multiply(LearningRate, output_delta))
  
    hidden_layer.weights = matrix_subtraction(hidden_layer.weights,
                                              scalar_multiply(LearningRate, dot_product(matrix_transpose(hidden_delta), matrix_transpose(input))))
    hidden_layer.bias = vector_subtraction(hidden_layer.bias,
                                           scalar_multiply(LearningRate, hidden_delta))
  end
  
  def dot_product(a, b)
    a.zip(b).map { |x, y| x * y }.reduce(:+)
  end
  
  def matrix_transpose(matrix)
    matrix.transpose
  end
  
  def matrix_subtraction(matrix_a, matrix_b)
    matrix_a.zip(matrix_b).map { |row_a, row_b| vector_subtraction(row_a, row_b) }
  end
  
  def scalar_multiply(scalar, vector)
    vector.map { |x| scalar * x }
  end
  
  def vector_subtraction(vector_a, vector_b)
    vector_a.zip(vector_b).map { |x, y| x - y }
  end
  
  input = [/* Input values here */]
  target = [/* Target values here */]
  
  hidden_layer = HiddenLayer.new(HiddenSize, InputSize)
  output_layer = OutputLayer.new(OutputSize, HiddenSize)
  
  Epochs.times do
    back_propagation(input, target, hidden_layer, output_layer)
  end
  
  output = forward_propagation(input, hidden_layer, output_layer)
  
  puts "Output: #{output}"
  