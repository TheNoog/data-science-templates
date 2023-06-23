% Load the dataset (Iris dataset as an example)
iris = readtable('iris.csv');
X = iris(:, 1:4);
y = iris(:, 5);

% Split the dataset into training and testing sets
rng('default'); % Set the random seed for reproducibility
[trainIndices, testIndices] = crossvalind('HoldOut', size(iris, 1), 0.2);
X_train = X(trainIndices, :);
y_train = y(trainIndices, :);
X_test = X(testIndices, :);
y_test = y(testIndices, :);

% Create a decision tree classifier
classifier = fitctree(X_train, y_train);

% Make predictions on the test data
y_pred = predict(classifier, X_test);

% Calculate the accuracy of the model
accuracy = sum(strcmp(y_pred, y_test)) / numel(y_test);
disp(['Accuracy: ', num2str(accuracy)]);
