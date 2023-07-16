// Define the number of samples and features
const N_SAMPLES = 100;
const N_FEATURES = 20;

// Function to calculate the mean squared error
function calculateMeanSquaredError(yTrue, yPred) {
  const n = yTrue.length;
  let mse = 0.0;
  for (let i = 0; i < n; i++) {
    const diff = yTrue[i] - yPred[i];
    mse += diff * diff;
  }
  return mse / n;
}

// Function to perform LASSO regression
function lassoRegression(X, y, coefficients, alpha) {
  // Maximum number of iterations for coordinate descent
  const maxIterations = 100;

  // Step size for coordinate descent
  const stepSize = 0.01;

  const nSamples = X.length;
  const nFeatures = X[0].length;

  // Initialize the coefficients to zero
  coefficients.fill(0.0);

  // Perform coordinate descent
  for (let iteration = 0; iteration < maxIterations; iteration++) {
    for (let j = 0; j < nFeatures; j++) {
      // Calculate the gradient for feature j
      let gradient = 0.0;
      for (let i = 0; i < nSamples; i++) {
        let pred = 0.0;
        for (let k = 0; k < nFeatures; k++) {
          if (k !== j) {
            pred += X[i][k] * coefficients[k];
          }
        }
        gradient += (y[i] - pred) * X[i][j];
      }

      // Update the coefficient using LASSO penalty
      if (gradient > alpha) {
        coefficients[j] = (gradient - alpha) * stepSize;
      } else if (gradient < -alpha) {
        coefficients[j] = (gradient + alpha) * stepSize;
      } else {
        coefficients[j] = 0.0;
      }
    }
  }
}

// Generate some synthetic data
function generateSyntheticData() {
  const X = new Array(N_SAMPLES).fill(null).map(() => new Array(N_FEATURES).fill(0));
  const y = new Array(N_SAMPLES).fill(0);

  const rng = new Math.seedrandom(42); // Use a random seed for reproducibility

  for (let i = 0; i < N_SAMPLES; i++) {
    for (let j = 0; j < N_FEATURES; j++) {
      X[i][j] = rng();
    }

    y[i] = 0.0;
    for (let j = 0; j < N_FEATURES; j++) {
      y[i] += X[i][j] * (j + 1);
    }
    y[i] += 0.1 * rng();
  }

  return { X, y };
}

// Main function
function main() {
  // Generate some synthetic data
  const { X, y } = generateSyntheticData();

  // Split the data into training and test sets
  const nTrainSamples = Math.floor(N_SAMPLES * 0.8);
  const nTestSamples = N_SAMPLES - nTrainSamples;
  const XTrain = X.slice(0, nTrainSamples);
  const yTrain = y.slice(0, nTrainSamples);
  const XTest = X.slice(nTrainSamples);
  const yTest = y.slice(nTrainSamples);

  // Perform LASSO regression
  const alpha = 0.1;
  const coefficients = new Array(N_FEATURES).fill(0.0);
  lassoRegression(XTrain, yTrain, coefficients, alpha);

  // Make predictions on the test set
  const yPred = XTest.map((sample) =>
    sample.reduce((acc, x, j) => acc + x * coefficients[j], 0)
  );

  // Calculate the mean squared error
  const mse = calculateMeanSquaredError(yTest, yPred);
  console.log("Mean Squared Error:", mse);

  // Print the true coefficients and the estimated coefficients
  console.log("True Coefficients:", [1.0, ...Array.from({ length: N_FEATURES - 1 }, (_, i) => i + 2)]);
  console.log("Estimated Coefficients:", coefficients);
}

main();
