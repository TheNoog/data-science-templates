% Load the training and testing data
trainData = readmatrix('train.csv');
testData = readmatrix('test.csv');

% Separate the features (X) and labels (y)
X_train = trainData(:, 2:end);
y_train = trainData(:, 1);
X_test = testData(:, 2:end);
y_test = testData(:, 1);

% Set the parameters for the XGBoost model
params = struct();
params.objective = 'reg:squarederror';
params.max_depth = 3;
params.eta = 0.1;
params.subsample = 0.8;
params.colsample_bytree = 0.8;

% Train the model
numRounds = 100;
model = xgboost_train(X_train, y_train, params, numRounds);

% Make predictions on the test data
predictions = xgboost_predict(model, X_test);

% Evaluate the model
rmse = sqrt(mean((y_test - predictions).^2));
fprintf('RMSE: %.4f\n', rmse);
