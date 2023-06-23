const xgboost = require('xgboost');

// Load the training and testing data
const trainData = xgboost.DMatrix({ data: 'train.libsvm' });
const testData = xgboost.DMatrix({ data: 'test.libsvm' });

// Set the parameters for the XGBoost model
const params = {
  objective: 'reg:squarederror',
  max_depth: 3,
  eta: 0.1,
  subsample: 0.8,
  colsample_bytree: 0.8,
};

// Train the model
const numRounds = 100;
const booster = xgboost.train(params, trainData, numRounds);

// Make predictions on the test data
const predictions = booster.predict(testData);

// Evaluate the model
const labels = testData.getLabel();
let sumSquaredError = 0;
for (let i = 0; i < labels.length; i++) {
  const error = labels[i] - predictions[i];
  sumSquaredError += error * error;
}
const rmse = Math.sqrt(sumSquaredError / labels.length);
console.log(`RMSE: ${rmse}`);
