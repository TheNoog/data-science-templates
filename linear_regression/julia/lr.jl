using Statistics
using LinearModels

# Example data
X = [1, 2, 3, 4, 5]  # Input features
y = [2, 4, 5, 4, 6]  # Target variable

# Create a linear regression model
model = lm(X, y)

# Predict on new data
new_X = [6, 7]
predictions = predict(model, new_X)

# Print the predictions
for (x, y_pred) in zip(new_X, predictions)
    println("Input: $x, Predicted Output: $y_pred")
end
