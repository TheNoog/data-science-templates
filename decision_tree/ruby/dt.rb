require 'csv'
require 'decisiontree'

# Load the dataset (Iris dataset as an example)
iris_data = CSV.read('iris.csv', converters: :numeric)
X = iris_data.map { |row| row[0..3] }
y = iris_data.map { |row| row[4] }

# Split the dataset into training and testing sets
split_ratio = 0.8
split_index = (iris_data.size * split_ratio).to_i
X_train = X[0...split_index]
y_train = y[0...split_index]
X_test = X[split_index..-1]
y_test = y[split_index..-1]

# Create a decision tree classifier
attributes = %w[sepal_length sepal_width petal_length petal_width]
classes = %w[Iris-setosa Iris-versicolor Iris-virginica]
classifier = DecisionTree::ID3Tree.new(attributes, classes)

# Train the classifier on the training data
training_data = X_train.zip(y_train)
classifier.train(training_data)

# Make predictions on the test data
y_pred = X_test.map { |instance| classifier.predict(instance) }

# Calculate the accuracy of the model
correct_predictions = y_pred.zip(y_test).count { |predicted, actual| predicted == actual }
accuracy = correct_predictions.to_f / y_test.size
puts "Accuracy: #{accuracy}"
