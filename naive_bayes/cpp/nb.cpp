#include <iostream>
#include <vector>
#include <cmath>

#define NUM_CLASSES 3
#define NUM_FEATURES 4

struct DataPoint {
    std::vector<float> features;
    int label;
};

struct Dataset {
    std::vector<DataPoint> data;
};

Dataset loadDataset() {
    // Load the dataset
    Dataset dataset;

    // Your code to load the data from a file or any other source goes here
    // Assign the features and labels to the data vector in the dataset struct

    return dataset;
}

void trainNaiveBayes(const Dataset& dataset, std::vector<float>& priors, std::vector<std::vector<float>>& likelihoods) {
    int numDataPoints = dataset.data.size();
    std::vector<int> classCounts(NUM_CLASSES, 0);

    // Count the occurrences of each class label
    for (const auto& dataPoint : dataset.data) {
        classCounts[dataPoint.label]++;
    }

    // Calculate priors
    for (int i = 0; i < NUM_CLASSES; i++) {
        priors[i] = static_cast<float>(classCounts[i]) / numDataPoints;
    }

    // Calculate likelihoods
    for (int i = 0; i < NUM_CLASSES; i++) {
        for (int j = 0; j < NUM_FEATURES; j++) {
            float featureSum = 0.0f;
            int featureCount = 0;

            // Sum the values of the feature for the current class
            for (const auto& dataPoint : dataset.data) {
                if (dataPoint.label == i) {
                    featureSum += dataPoint.features[j];
                    featureCount++;
                }
            }

            // Calculate the average of the feature for the current class
            likelihoods[i][j] = featureSum / featureCount;
        }
    }
}

int predict(const DataPoint& dataPoint, const std::vector<float>& priors, const std::vector<std::vector<float>>& likelihoods) {
    float maxPosterior = 0.0f;
    int predictedClass = -1;

    // Calculate the posterior probability for each class
    for (int i = 0; i < NUM_CLASSES; i++) {
        float posterior = priors[i];

        for (int j = 0; j < NUM_FEATURES; j++) {
            posterior *= expf(-(powf(dataPoint.features[j] - likelihoods[i][j], 2.0f) / 2));
        }

        // Update the predicted class if the posterior is higher than the current maximum
        if (posterior > maxPosterior) {
            maxPosterior = posterior;
            predictedClass = i;
        }
    }

    return predictedClass;
}

int main() {
    Dataset dataset = loadDataset();
    std::vector<float> priors(NUM_CLASSES);
    std::vector<std::vector<float>> likelihoods(NUM_CLASSES, std::vector<float>(NUM_FEATURES));

    trainNaiveBayes(dataset, priors, likelihoods);

    // Example usage: Predict the class label for a new data point
    DataPoint newDataPoint;
    newDataPoint.features.push_back(5.1f);
    newDataPoint.features.push_back(3.5f);
    newDataPoint.features.push_back(1.4f);
    newDataPoint.features.push_back(0.2f);

    int predictedLabel = predict(newDataPoint, priors, likelihoods);
    std::cout << "Predicted Label: " << predictedLabel << std::endl;

    return 0;
}
