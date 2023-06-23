import h2o
from h2o.estimators import NaiveBayes
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Initialize H2O
h2o.init()

# Load the Iris dataset
iris = load_iris()
X = iris.data
y = iris.target

# Convert the data to an H2O Frame
data = h2o.H2OFrame(list(X) + list(y), column_names=['sepal_length', 'sepal_width', 'petal_length', 'petal_width', 'class'])

# Split the data into training and test sets
train, test = data.split_frame(ratios=[0.8])

# Define the features and target column names
features = ['sepal_length', 'sepal_width', 'petal_length', 'petal_width']
target = 'class'

# Create a Naive Bayes estimator
nb = NaiveBayes()

# Train the estimator using the training data
nb.train(x=features, y=target, training_frame=train)

# Make predictions on the test data
predictions = nb.predict(test)

# Convert the H2O Frame to a list
predictions = predictions['predict'].as_data_frame()['predict'].tolist()

# Extract the true labels from the H2O Frame
true_labels = test[target].as_data_frame()[target].tolist()

# Calculate the accuracy of the classifier
accuracy = accuracy_score(true_labels, predictions)
print("Accuracy:", accuracy)

# Shutdown H2O
h2o.shutdown()
