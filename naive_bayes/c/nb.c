#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NUM_CLASSES 3
#define NUM_FEATURES 4

struct DataPoint {
    float features[NUM_FEATURES];
    int label;
};

struct Dataset {
    struct DataPoint* data;
    int numDataPoints;
};

struct Dataset loadDataset() {
    // Load the dataset
    struct Dataset dataset;
    dataset.numDataPoints = 150;  // Number of data points in the Iris dataset
    dataset.data = (struct DataPoint*)malloc(dataset.numDataPoints * sizeof(struct DataPoint));

    // Your code to load the data from a file or any other source goes here
    // Assign the features and labels to the data array in the dataset struct

    return dataset;
}

void trainNaiveBayes(struct Dataset dataset, float priors[NUM_CLASSES], float likelihoods[NUM_CLASSES][NUM_FEATURES]) {
    int i, j;
    int classCounts[NUM_CLASSES] = {0};

    // Count the occurrences of each class label
    for (i = 0; i < dataset.numDataPoints; i++) {
        classCounts[dataset.data[i].label]++;
    }

    // Calculate priors
    for (i = 0; i < NUM_CLASSES; i++) {
        priors[i] = (float)classCounts[i] / dataset.numDataPoints;
    }

    // Calculate likelihoods
    for (i = 0; i < NUM_CLASSES; i++) {
        for (j = 0; j < NUM_FEATURES; j++) {
            float featureSum = 0.0f;
            int featureCount = 0;

            // Sum the values of the feature for the current class
            for (int k = 0; k < dataset.numDataPoints; k++) {
                if (dataset.data[k].label == i) {
                    featureSum += dataset.data[k].features[j];
                    featureCount++;
                }
            }

            // Calculate the average of the feature for the current class
            likelihoods[i][j] = featureSum / featureCount;
        }
    }
}

int predict(struct DataPoint dataPoint, float priors[NUM_CLASSES], float likelihoods[NUM_CLASSES][NUM_FEATURES]) {
    int i, j;
    float maxPosterior = 0.0f;
    int predictedClass = -1;

    // Calculate the posterior probability for each class
    for (i = 0; i < NUM_CLASSES; i++) {
        float posterior = priors[i];

        for (j = 0; j < NUM_FEATURES; j++) {
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
    struct Dataset dataset = loadDataset();
    float priors[NUM_CLASSES];
    float likelihoods[NUM_CLASSES][NUM_FEATURES];

    trainNaiveBayes(dataset, priors, likelihoods);

    // Example usage: Predict the class label for a new data point
    struct DataPoint newDataPoint;
    newDataPoint.features[0] = 5.1f;
    newDataPoint.features[1] = 3.5f;
    newDataPoint.features[2] = 1.4f;
    newDataPoint.features[3] = 0.2f;

    int predictedLabel = predict(newDataPoint, priors, likelihoods);
    printf("Predicted Label: %d\n", predictedLabel);

    // Free the allocated memory
    free(dataset.data);

    return 0;
}
