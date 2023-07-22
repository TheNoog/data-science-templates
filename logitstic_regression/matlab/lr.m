function [weights, bias, newLabel] = logisticRegression(features, label)
  % Initialize weights and bias
  weights = zeros(size(features, 1));
  bias = 0;

  % Train the model
  for i = 1:100
    prediction = sigmoid(weights'*features + bias);
    error = label - prediction;

    weights = weights + error*features;
    bias = bias + error;
  end

  % Predict the label for a new data point
  newFeatures = [3, 4];
  newLabel = sigmoid(weights'*newFeatures + bias) > 0.5;

end

% Initialize data
features = [1, 2];
label = 1;

% Train the model
[weights, bias, newLabel] = logisticRegression(features, label);

% Print the predicted label
disp(newLabel)
