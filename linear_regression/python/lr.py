import numpy as np
from sklearn.linear_model import LinearRegression

# Example data
X = np.array([[1], [2], [3], [4], [5]])  # Input features
y = np.array([2, 4, 5, 4, 6])  # Target variable

# Create a linear regression model
model = LinearRegression()

# Train the model
model.fit(X, y)

# Predict on new data
new_X = np.array([[6], [7]])
predictions = model.predict(new_X)

# Print the predictions
for x, y_pred in zip(new_X, predictions):
    print(f"Input: {x}, Predicted Output: {y_pred}")
