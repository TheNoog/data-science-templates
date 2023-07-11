#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

// Structure to represent a data point
struct DataPoint {
    double x;
    double y;
    int label;
};

// Function to calculate Euclidean distance between two data points
double calculateDistance(const DataPoint& p1, const DataPoint& p2) {
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;
    return std::sqrt(dx * dx + dy * dy);
}

// Function to perform KNN classification
int classify(const std::vector<DataPoint>& trainingData, const DataPoint& testPoint, int k) {
    // Calculate distances to all training data points
    std::vector<double> distances;
    for (const auto& dataPoint : trainingData) {
        distances.push_back(calculateDistance(dataPoint, testPoint));
    }

    // Sort the distances in ascending order
    std::sort(distances.begin(), distances.end());

    // Count the occurrences of each label among the k nearest neighbors
    std::vector<int> labelCount(2, 0); // Assuming 2 classes (0 and 1)
    for (int i = 0; i < k; i++) {
        int index = std::distance(distances.begin(), std::find(distances.begin(), distances.end(), distances[i]));
        labelCount[trainingData[index].label]++;
    }

    // Return the label with the highest count
    if (labelCount[0] > labelCount[1]) {
        return 0;
    } else {
        return 1;
    }
}

int main() {
    // Training data
    std::vector<DataPoint> trainingData = {
        {2.0, 4.0, 0},
        {4.0, 6.0, 0},
        {4.0, 8.0, 1},
        {6.0, 4.0, 1},
        {6.0, 6.0, 1}
    };

    // Test data point
    DataPoint testPoint = {5.0, 5.0, 0};

    // Perform KNN classification
    int k = 3;
    int predictedLabel = classify(trainingData, testPoint, k);

    // Print the predicted label
    std::cout << "Predicted label: " << predictedLabel << std::endl;

    return 0;
}