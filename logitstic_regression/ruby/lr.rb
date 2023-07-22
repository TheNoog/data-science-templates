class LogisticRegression
    attr_reader :weights, :bias
  
    def initialize(feature_count)
      @weights = Array.new(feature_count) { 0.0 }
      @bias = 0.0
    end
  
    def train(features, label)
      prediction = sigmoid(dot(features, weights) + bias)
      error = label - prediction
  
      for i in 0..(weights.length - 1) do
        weights[i] += error * features[i]
      end
      bias += error
    end
  
    def sigmoid(x)
      1.0 / (1.0 + Math.exp(-x))
    end
  
    def dot(features, weights)
      sum = 0.0
      for i in 0..(features.length - 1) do
        sum += features[i] * weights[i]
      end
  
      sum
    end
  
    def predict(features)
      sigmoid(dot(features, weights) + bias) > 0.5
    end
  end
  
  def main()
    features = [1.0, 2.0]
    label = 1
  
    model = LogisticRegression.new(2)
  
    for i in 0..100 do
      model.train(features, label)
    end
  
    new_features = [3.0, 4.0]
    new_label = model.predict(new_features)
  
    puts "The predicted label is #{new_label}"
  end
  
  main()
  