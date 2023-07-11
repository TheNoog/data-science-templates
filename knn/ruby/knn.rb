# Structure to represent a data point
class DataPoint
    attr_accessor :x, :y, :label
  
    def initialize(x, y, label)
      @x = x
      @y = y
      @label = label
    end
  end
  
  # Function to calculate Euclidean distance between two data points
  def calculate_distance(p1, p2)
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    Math.sqrt(dx**2 + dy**2)
  end
  
  # Function to perform KNN classification
  def classify(training_data, test_point, k)
    # Calculate distances to all training data points
    distances = training_data.map { |data_point| calculate_distance(data_point, test_point) }
  
    # Sort the distances in ascending order
    sorted_distances = distances.sort
  
    # Count the occurrences of each label among the k nearest neighbors
    label_count = Hash.new(0)
    sorted_distances[0...k].each do |distance|
      index = distances.index(distance)
      label = training_data[index].label
      label_count[label] += 1
    end
  
    # Return the label with the highest count
    label_count.max_by { |_label, count| count }[0]
  end
  
  # Training data
  training_data = [
    DataPoint.new(2.0, 4.0, 0),
    DataPoint.new(4.0, 6.0, 0),
    DataPoint.new(4.0, 8.0, 1),
    DataPoint.new(6.0, 4.0, 1),
    DataPoint.new(6.0, 6.0, 1)
  ]
  
  # Test data point
  test_point = DataPoint.new(5.0, 5.0, 0)
  
  # Perform KNN classification
  k = 3
  predicted_label = classify(training_data, test_point, k)
  
  # Print the predicted label
  puts "Predicted label: #{predicted_label}"
  