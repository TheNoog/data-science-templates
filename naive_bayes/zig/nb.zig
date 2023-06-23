const std = @import("std");

// DataPoint struct
const DataPoint = struct {
    features: [4]f64,
    label: usize,
};

// Dataset struct
const Dataset = struct {
    data: []DataPoint,
};

// Function to load the dataset
fn loadDataset() !Dataset {
    // Load the dataset
    var data: [0]DataPoint = undefined;

    // Your code to load the data from a file or any other source goes here
    // Append each data point as a DataPoint struct to the data slice

    return Dataset{ .data = data };
}

// Function to train the Naive Bayes classifier
fn trainNaiveBayes(dataset: &Dataset) (pri: [3]f64, like: [3][4]f64) {
    const numDataPoints: usize = dataset.data.len;
    const numClasses: usize = 3;  // Number of classes in your dataset
    const numFeatures: usize = 4;  // Number of features in your dataset

    var classCounts: [3]usize = undefined;
    var priors: [3]f64 = undefined;
    var likelihoods: [3][4]f64 = undefined;

    // Count the occurrences of each class label
    for (dataset.data) |dataPoint| {
        classCounts[dataPoint.label] += 1;
    }

    // Calculate priors
    var totalDataPoints: usize = 0;
    for (classCounts) |count, index| {
        totalDataPoints += count;
    }
    for (classCounts) |count, index| {
        priors[index] = f64(count) / f64(totalDataPoints);
    }

    // Calculate likelihoods
    for (likelihoods) |_, index| {
        var featureSum: [4]f64 = undefined;
        var featureCount: [4]usize = undefined;

        // Sum the values of the feature for the current class
        for (dataset.data) |dataPoint| {
            if (dataPoint.label == index) {
                for (dataPoint.features) |feature, fIndex| {
                    featureSum[fIndex] += feature;
                    featureCount[fIndex] += 1;
                }
            }
        }

        // Calculate the average of the feature for the current class
        for (featureSum) |sum, fIndex| {
            likelihoods[index][fIndex] = sum / f64(featureCount[fIndex]);
        }
    }

    return (pri, like);
}

// Function to predict the class label for a new data point
fn predict(dataPoint: &DataPoint, priors: [3]f64, likelihoods: [3][4]f64) usize {
    const numClasses: usize = priors.len;
    const numFeatures: usize = likelihoods[0].len;
    var maxPosterior: f64 = 0.0;
    var predictedLabel: usize = 0;

    // Calculate the posterior probability for each class
    for (likelihoods) |likelihoodSet, index| {
        var posterior: f64 = priors[index];

        for (dataPoint.features) |feature, fIndex| {
            posterior *= f64.exp(-f64.pow(f64(dataPoint.features[fIndex]) - likelihoodSet[fIndex], 2) / 2);
        }

        // Update the predicted class if the posterior is higher than the current maximum
        if (posterior > maxPosterior) {
            maxPosterior = posterior;
            predictedLabel = index;
        }
    }

    return predictedLabel;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var dataset = try loadDataset();
    const (priors, likelihoods) = trainNaiveBayes(&dataset);

    // Example usage: Predict the class label for a new data point
    const newDataPoint = DataPoint{ .features = [5.1, 3.5, 1.4, 0.2], .label = 0 };
    const predictedLabel = predict(&newDataPoint, priors, likelihoods);

    try stdout.print("Predicted Label: {}\n", .{predictedLabel});
}
