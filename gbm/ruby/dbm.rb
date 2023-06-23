require 'xgboost'

# Load the training and testing data
train_data = XGBoost::DMatrix.new('train.libsvm')
test_data = XGBoost::DMatrix.new('test.libsvm')

# Set the parameters for the XGBoost model
params = {
  objective: 'reg:squarederror',
  max_depth: 3,
  eta: 0.1,
  subsample: 0.8,
  colsample_bytree: 0.8
}

# Train the model
num_rounds = 100
model = XGBoost.train(params, train_data, num_rounds)

# Make predictions on the test data
predictions = model.predict(test_data)

# Evaluate the model
labels = test_data.labels
rmse = Math.sqrt((labels - predictions).map { |x| x**2 }.sum / labels.length)
puts "RMSE: #{rmse}"
