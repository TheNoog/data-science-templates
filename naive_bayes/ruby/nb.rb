class DataPoint
    attr_accessor :features, :label
  
    def initialize(features, label)
      @features = features
      @label = label
    end
  end
  
  class Dataset
    attr_accessor :data
  
    def initialize(data)
      @data = data
    end
  end
  
  def load_dataset
    # Load the dataset
    data = []
  
    # Your code to load the data from a file or any other source goes here
    # Push each data point as a DataPoint object to the data array
  
    Dataset.new(data)
  end
  
  def train_naive_bayes(dataset)
    num_data_points = dataset.data.length
    num_classes = 3  # Number of classes in your dataset
    num_features = 4  # Number of features in your dataset
  
    class_counts = Array.new(num_classes, 0)
    priors = Array.new(num_classes, 0.0)
    likelihoods = Array.new(num_classes) { Array.new(num_features, 0.0) }
  
    # Count the occurrences of each class label
    dataset.data.each do |data_point|
      class_counts[data_point.label] += 1
    end
  
    # Calculate priors
    for i in 0...num_classes
      priors[i] = class_counts[i] / num_data_points.to_f
    end
  
    # Calculate likelihoods
    for i in 0...num_classes
      for j in 0...num_features
        feature_sum = 0.0
        feature_count = 0
  
        # Sum the values of the feature for the current class
        dataset.data.each do |data_point|
          if data_point.label == i
            feature_sum += data_point.features[j]
            feature_count += 1
          end
        end
  
        # Calculate the average of the feature for the current class
        likelihoods[i][j] = feature_sum / feature_count.to_f
      end
    end
  
    return priors, likelihoods
  end
  
  def predict(data_point, priors, likelihoods)
    num_classes = priors.length
    num_features = likelihoods[0].length
    max_posterior = 0.0
    predicted_label = -1
  
    # Calculate the posterior probability for each class
    for i in 0...num_classes
      posterior = priors[i]
  
      for j in 0...num_features
        posterior *= Math.exp(-(data_point.features[j] - likelihoods[i][j])**2 / 2)
      end
  
      # Update the predicted class if the posterior is higher than the current maximum
      if posterior > max_posterior
        max_posterior = posterior
        predicted_label = i
      end
    end
  
    return predicted_label
  end
  
  # Main program
  dataset = load_dataset
  priors, likelihoods = train_naive_bayes(dataset)
  
  # Example usage: Predict the class label for a new data point
  new_data_point = DataPoint.new([5.1, 3.5, 1.4, 0.2], 0)
  
  predicted_label = predict(new_data_point, priors, likelihoods)
  puts "Predicted Label: #{predicted_label}"
  