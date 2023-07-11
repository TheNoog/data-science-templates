import math
from collections import Counter

# Structure to represent a data point
class DataPoint:
    def __init__(self, x, y, label):
        self.x = x
        self.y = y
        self.label = label

# Function to calculate Euclidean distance between two data points
def calculate_distance(p1, p2):
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    return math.sqrt(dx * dx + dy * dy)

# Function to perform KNN classification
def classify(training_data, test_point, k):
    # Calculate distances to all training data points
    distances = [calculate_distance(data_point, test_point) for data_point in training_data]

    # Sort the distances in ascending order
    sorted_distances = sorted(distances)

    # Count the occurrences of each label among the k nearest neighbors
    label_count = Counter()
    for i in range(k):
        index = distances.index(sorted_distances[i])
        label = training_data[index].label
        label_count[label] += 1

    # Return the label with the highest count
    return label_count.most_common(1)[0][0]

# Training data
training_data = [
    DataPoint(2.0, 4.0, 0),
    DataPoint(4.0, 6.0, 0),
    DataPoint(4.0, 8.0, 1),
    DataPoint(6.0, 4.0, 1),
    DataPoint(6.0, 6.0, 1)
]

# Test data point
test_point = DataPoint(5.0, 5.0, 0)

# Perform KNN classification
k = 3
predicted_label = classify(training_data, test_point, k)

# Print the predicted label
print("Predicted label:", predicted_label)