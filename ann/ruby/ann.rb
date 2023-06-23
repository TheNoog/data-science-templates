class NeuralNetwork
    def initialize(input_size, hidden_size, output_size, learning_rate)
      @weights1 = Array.new(input_size) { Array.new(hidden_size) { rand } }
      @weights2 = Array.new(hidden_size) { Array.new(output_size) { rand } }
      @biases1 = Array.new(hidden_size) { rand }
      @biases2 = Array.new(output_size) { rand }
      @learning_rate = learning_rate
    end
  
    def activation(x)
      1 / (1 + Math.exp(-x))
    end
  
    def derivative(x)
      activation(x) * (1 - activation(x))
    end
  
    def train(x, y, epochs)
      epochs.times do
        # Forward pass
        hidden_layer = x.map { |row| row.zip(@weights1, @biases1).map { |x, w, b| x * w + b } }
                        .map { |row| row.map { |x| activation(x) } }
        output_layer = hidden_layer.map { |row| row.zip(@weights2, @biases2).map { |x, w, b| x * w + b } }
                        .map { |row| row.map { |x| activation(x) } }
  
        # Backpropagation
        output_layer_error = y.zip(output_layer).map { |expected, actual| expected - actual }
        output_layer_delta = output_layer.map { |row| row.map { |x| derivative(x) } }
        output_layer_error_delta = output_layer_error.zip(output_layer_delta)
                                   .map { |error, delta| error * delta }
  
        hidden_layer_error = output_layer_error_delta.map { |row| row.zip(@weights2.transpose).map { |e, w| e * w } }
                             .map { |row| row.map { |x| derivative(x) } }
        hidden_layer_error_delta = hidden_layer_error.zip(hidden_layer_delta)
                                   .map { |error, delta| error * delta }
  
        # Weight and bias adjustments
        hidden_layer_adjustment = x.transpose.map { |col| col.zip(hidden_layer_error_delta).map { |x, e| x * e } }
        output_layer_adjustment = hidden_layer.transpose.map { |col| col.zip(output_layer_error_delta).map { |x, e| x * e } }
  
        @weights1 = @weights1.zip(hidden_layer_adjustment).map { |w, adj| w.zip(adj).map { |x, a| x + @learning_rate * a } }
        @weights2 = @weights2.zip(output_layer_adjustment).map { |w, adj| w.zip(adj).map { |x, a| x + @learning_rate * a } }
  
        @biases1 = @biases1.zip(hidden_layer_error_delta.transpose).map { |b, err| b + @learning_rate * err.sum }
        @biases2 = @biases2.zip(output_layer_error_delta.transpose).map { |b, err| b + @learning_rate * err.sum }
      end
    end
  
    def predict(x)
      hidden_layer = x.map { |row| row.zip(@weights1, @biases1).map { |x, w, b| x * w + b } }
                      .map { |row| row.map { |x| activation(x) } }
      output_layer = hidden_layer.map { |row| row.zip(@weights2, @biases2).map { |x, w, b| x * w + b } }
                      .map { |row| row.map { |x| activation(x) } }
      output_layer
    end
  end
  
  # Example usage
  x = [[0, 0], [0, 1], [1, 0], [1, 1]]
  y = [[0], [1], [1], [0]]
  
  nn = NeuralNetwork.new(2, 4, 1, 0.1)
  epochs = 1000
  nn.train(x, y, epochs)
  
  predictions = nn.predict(x)
  puts "Predicted Output:"
  puts predictions.inspect
  