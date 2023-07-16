import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import Lasso
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

# Generate some synthetic data
np.random.seed(42)
n_samples = 100
n_features = 20
X = np.random.rand(n_samples, n_features)
coefficients = np.zeros(n_features)
coefficients[0:5] = 1.0  # First 5 features are important
y = np.dot(X, coefficients) + np.random.normal(0, 0.1, n_samples)

# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create and fit the Lasso regression model
alpha = 0.1  # L1 regularization strength (the higher, the more regularization)
lasso_model = Lasso(alpha=alpha)
lasso_model.fit(X_train, y_train)

# Make predictions on the test set
y_pred = lasso_model.predict(X_test)

# Calculate the mean squared error
mse = mean_squared_error(y_test, y_pred)
print(f"Mean Squared Error: {mse:.4f}")

# Plot the true coefficients and the estimated coefficients
plt.figure(figsize=(10, 6))
plt.plot(coefficients, label='True Coefficients', marker='o')
plt.plot(lasso_model.coef_, label='Estimated Coefficients', marker='x')
plt.xlabel('Feature Index')
plt.ylabel('Coefficient Value')
plt.legend()
plt.title('True vs. Estimated Coefficients')
plt.show()
