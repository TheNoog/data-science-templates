using DecisionTree, RDatasets

# Load the dataset (Iris dataset as an example)
iris = dataset("datasets", "iris")

# Split the dataset into features and labels
X = Matrix(iris[:, 1:4])
y = iris[:, :Species]

# Split the dataset into training and testing sets
split_ratio = 0.8
n = size(X, 1)
train_indices = randperm(n)[1:div(n * split_ratio, 1)]
test_indices = setdiff(1:n, train_indices)

X_train = X[train_indices, :]
y_train = y[train_indices, :]
X_test = X[test_indices, :]
y_test = y[test_indices, :]

# Create a decision tree classifier
classifier = build_tree(y_train, X_train)

# Make predictions on the test data
y_pred = apply_tree(classifier, X_test)

# Calculate the accuracy of the model
accuracy = sum(y_pred .== y_test) / length(y_test)
println("Accuracy: ", accuracy)
