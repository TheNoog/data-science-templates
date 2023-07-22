import numpy as np
import ray
from ray.ml.classification import LogisticRegression

# Initialize Ray
ray.init()

# Load the data
data = np.loadtxt("data.csv", delimiter=",")

# Split the data into features and labels
X = data[:, :-1]
y = data[:, -1]

# Create a logistic regression model
model = LogisticRegression()

# Fit the model to the data
model.fit(X, y)

# Predict the labels for the test data
y_pred = model.predict(X)

# Print the accuracy of the model
accuracy = np.mean(y == y_pred)
print("Accuracy:", accuracy)
