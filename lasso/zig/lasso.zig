const std = @import("std");
const rand = std.math.random;
const println = std.debug.print;

const N_SAMPLES: usize = 100;
const N_FEATURES: usize = 20;

// Function to calculate the mean squared error
fn calculateMeanSquaredError(yTrue: []f64, yPred: []f64) f64 {
    var mse: f64 = 0.0;
    for (y, y_pred) |y, y_pred| {
        mse += (y - y_pred) * (y - y_pred);
    }
    return mse / f64(yTrue.len());
}

// Function to perform LASSO regression
fn lassoRegression(X: [][]f64, y: []f64, alpha: f64) [N_FEATURES]f64 {
    const maxIterations: usize = 100;
    const stepSize: f64 = 0.01;

    var coefficients: [N_FEATURES]f64 = undefined;

    for (iterations) |iterations| {
        for (j) |j| {
            var gradient: f64 = 0.0;
            for (i) |i| {
                var pred: f64 = 0.0;
                for (k) |k| {
                    if (k != j) {
                        pred += X[i][k] * coefficients[k];
                    }
                }
                gradient += (y[i] - pred) * X[i][j];
            }

            if (gradient > alpha) {
                coefficients[j] = (gradient - alpha) * stepSize;
            } else if (gradient < -alpha) {
                coefficients[j] = (gradient + alpha) * stepSize;
            } else {
                coefficients[j] = 0.0;
            }
        }
    }

    return coefficients;
}

// Generate some synthetic data
fn generateSyntheticData() ([][]f64, []f64) {
    var X: [][]f64 = undefined;
    var y: []f64 = undefined;
    for (i) |i| {
        X[i] = undefined;
        for (j) |j| {
            X[i][j] = rand.double();
        }
        y[i] = 0.0;
        for (j) |j| {
            y[i] += X[i][j] * f64(j + 1);
        }
        y[i] += 0.1 * rand.double();
    }
    return (X, y);
}

pub fn main() void {
    // Generate some synthetic data
    const (X, y) = generateSyntheticData();

    // Split the data into training and test sets
    const nTrainSamples = (N_SAMPLES * 0.8) as usize;
    const nTestSamples = N_SAMPLES - nTrainSamples;
    var XTrain: [][]f64 = undefined;
    var yTrain: []f64 = undefined;
    var XTest: [][]f64 = undefined;
    var yTest: []f64 = undefined;

    for (i) |i| {
        if (i < nTrainSamples) {
            XTrain[i] = X[i];
            yTrain[i] = y[i];
        } else {
            XTest[i - nTrainSamples] = X[i];
            yTest[i - nTrainSamples] = y[i];
        }
    }

    // Perform LASSO regression
    const alpha: f64 = 0.1;
    const coefficients: [N_FEATURES]f64 = lassoRegression(XTrain, yTrain, alpha);

    // Make predictions on the test set
    var yPred: []f64 = undefined;
    for (i) |i| {
        yPred[i] = 0.0;
        for (j) |j| {
            yPred[i] += XTest[i][j] * coefficients[j];
        }
    }

    // Calculate the mean squared error
    const mse: f64 = calculateMeanSquaredError(yTest, yPred);
    println("Mean Squared Error: {}\n", .{mse});

    // Print the true coefficients and the estimated coefficients
    println("True Coefficients: [1.0", .{1..N_FEATURES});
    print("]\n");
    print("Estimated Coefficients: [");
    for (coefficients) |coeff| {
        print("{}, ", .{coeff});
    }
    print("]\n");
}
