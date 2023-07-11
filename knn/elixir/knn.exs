defmodule KNN do
  # Structure to represent a data point
  defstruct x: nil, y: nil, label: nil

  # Function to calculate Euclidean distance between two data points
  def calculate_distance(p1, p2) do
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    :math.sqrt(dx * dx + dy * dy)
  end

  # Function to perform KNN classification
  def classify(training_data, test_point, k) do
    # Calculate distances to all training data points
    distances = for data_point <- training_data, do: calculate_distance(data_point, test_point)

    # Sort the distances in ascending order
    sorted_distances = Enum.sort(distances)

    # Count the occurrences of each label among the k nearest neighbors
    label_count = Enum.map(1..k, fn i ->
      index = Enum.find_index(sorted_distances, &(elem(&1, 1) == distances[i]))
      Enum.at(training_data[index].label, 0)
    end) |> Enum.frequencies()

    # Return the label with the highest count
    case label_count do
      [{label, count}] -> label
      _ -> Enum.max_by(label_count, fn {_label, count} -> count end) |> elem(0)
    end
  end
end

# Training data
training_data = [
  %KNN{x: 2.0, y: 4.0, label: 0},
  %KNN{x: 4.0, y: 6.0, label: 0},
  %KNN{x: 4.0, y: 8.0, label: 1},
  %KNN{x: 6.0, y: 4.0, label: 1},
  %KNN{x: 6.0, y: 6.0, label: 1}
]

# Test data point
test_point = %KNN{x: 5.0, y: 5.0, label: 0}

# Perform KNN classification
k = 3
predicted_label = KNN.classify(training_data, test_point, k)

# Print the predicted label
IO.puts("Predicted label: #{predicted_label}")