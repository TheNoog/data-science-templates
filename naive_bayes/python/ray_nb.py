import numpy as np
import ray
from ray.util.joblib import register_ray

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score

# Initialize Ray
ray.init()

# Register Ray with joblib
register_ray()

# Load the Iris dataset
iris = load_iris()
X = iris.data
y = iris.target

# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a Gaussian Naive Bayes classifier
clf = GaussianNB()

# Train the classifier using Ray
@ray.remote
def train_classifier(X, y):
    clf.fit(X, y)

# Parallelize the training across multiple workers
# Assume you have 4 workers available
num_workers = 4
result_ids = [train_classifier.remote(X_train, y_train) for _ in range(num_workers)]
ray.get(result_ids)  # Wait for all workers to finish

# Make predictions on the test data
y_pred = clf.predict(X_test)

# Calculate the accuracy of the classifier
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)

# Shutdown Ray
ray.shutdown()
