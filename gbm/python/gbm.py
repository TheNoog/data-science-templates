import xgboost as xgb
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

# Load the Boston Housing dataset
boston = load_boston()
X = boston.data
y = boston.target

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create the gradient boosted model
model = xgb.XGBRegressor(
    objective='reg:squarederror',  # Specify the loss function for regression
    n_estimators=100,  # Number of boosting rounds (trees)
    learning_rate=0.1,  # Learning rate (shrinkage) of each tree
    max_depth=3,  # Maximum depth of each tree
    subsample=0.8,  # Fraction of training samples used for each tree
    colsample_bytree=0.8,  # Fraction of features used for each tree
    random_state=42
)

# Train the model
model.fit(X_train, y_train)

# Make predictions on the test set
y_pred = model.predict(X_test)

# Evaluate the model
mse = mean_squared_error(y_test, y_pred)
print("Mean Squared Error:", mse)
