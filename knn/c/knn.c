#include <stdio.h>
#include <math.h>

// Structure to represent a data point
struct DataPoint {
    double x;
    double y;
    int label;
};

// Function to calculate Euclidean distance between two data points
double calculateDistance(struct DataPoint p1, struct DataPoint p2) {
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;
    return sqrt(dx*dx + dy*dy);
}

// Function to perform KNN classification
int classify(struct DataPoint* trainingData, int dataSize, struct DataPoint testPoint, int k) {
    // Calculate distances to all training data points
    double distances[dataSize];
    for (int i = 0; i < dataSize; i++) {
        distances[i] = calculateDistance(trainingData[i], testPoint);
    }
    
    // Sort the distances in ascending order
    for (int i = 0; i < dataSize - 1; i++) {
        for (int j = 0; j < dataSize - i - 1; j++) {
            if (distances[j] > distances[j + 1]) {
                double temp = distances[j];
                distances[j] = distances[j + 1];
                distances[j + 1] = temp;
                
                struct DataPoint tempPoint = trainingData[j];
                trainingData[j] = trainingData[j + 1];
                trainingData[j + 1] = tempPoint;
            }
        }
    }
    
    // Count the occurrences of each label among the k nearest neighbors
    int labelCount[2] = {0};  // Assuming 2 classes (0 and 1)
    for (int i = 0; i < k; i++) {
        labelCount[trainingData[i].label]++;
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
    struct DataPoint trainingData[] = {
        {2.0, 4.0, 0},
        {4.0, 6.0, 0},
        {4.0, 8.0, 1},
        {6.0, 4.0, 1},
        {6.0, 6.0, 1}
    };
    int dataSize = sizeof(trainingData) / sizeof(trainingData[0]);
    
    // Test data point
    struct DataPoint testPoint = {5.0, 5.0, 0};
    
    // Perform KNN classification
    int k = 3;
    int predictedLabel = classify(trainingData, dataSize, testPoint, k);
    
    // Print the predicted label
    printf("Predicted label: %d\n", predictedLabel);
    
    return 0;
}