# Structure to represent a data point
struct DataPoint
    x::Float64
    y::Float64
    label::Int
end

# Function to calculate Euclidean distance between two data points
function calculate_distance(p1::DataPoint, p2::DataPoint)
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    return sqrt(dx * dx + dy * dy)
end

# Function to perform KNN classification
function classify(training_data::Vector{DataPoint}, test_point::DataPoint, k::Int)
    # Calculate distances to all training data points
    distances = [calculate_distance(data_point, test_point) for data_point in training_data]

    # Sort the distances in ascending order
    sorted_distances = sort(distances)

    # Count the occurrences of each label among the k nearest neighbors
    label_count = Dict{Int, Int}()
    for i in 1:k
        index = findfirst(==(sorted_distances[i]), distances)
        label = training_data[index].label
        label_count[label] = get(label_count, label, 0) + 1
    end

    # Return the label with the highest count
    max_count = maximum(values(label_count))
    predicted_label = findfirst(count -> count == max_count, values(label_count))
    return predicted_label
end

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
println("Predicted label: $predicted_label")
