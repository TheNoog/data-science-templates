import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier

# Load the data
X = np.load("images.npy")
y = np.load("labels.npy")

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Reshape the input data
X_train = X_train.reshape(X_train.shape[0], -1)
X_test = X_test.reshape(X_test.shape[0], -1)

# Normalize the input data
X_train = X_train / 255.0
X_test = X_test / 255.0

# Define the CNN model
model = MLPClassifier(hidden_layer_sizes=(32, 64, 128),
                      activation='relu',
                      solver='adam',
                      max_iter=10,
                      random_state=42)

# Train the model
model.fit(X_train, y_train)

# Evaluate the model
accuracy = model.score(X_test, y_test)
print("Accuracy:", accuracy)
