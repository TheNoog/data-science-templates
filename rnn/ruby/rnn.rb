class RNN

    def initialize(input_dim, hidden_dim, output_dim)
      @input_dim = input_dim
      @hidden_dim = hidden_dim
      @output_dim = output_dim
  
      @weights = Array.new(@input_dim) { Array.new(@hidden_dim) { rand - 0.5 } }
      @biases = Array.new(@hidden_dim) { rand - 0.5 }
  
      @h = Array.new(@hidden_dim)
    end
  
    def train(data)
      data.each do |sequence|
        sequence.each do |t|
          z = 0
          for i in 0...@input_dim
            z += t * @weights[i][@h.size]
          end
          @h.push(Math.tanh(z + @biases[@h.size]))
        end
      end
    end
  
    def predict(data)
      predictions = []
      @h = Array.new(@hidden_dim)
      data.each do |t|
        z = 0
        for i in 0...@input_dim
          z += t * @weights[i][@h.size]
        end
        @h.push(Math.tanh(z + @biases[@h.size]))
        predictions.push(@h.last)
      end
      return predictions
    end
  end
  