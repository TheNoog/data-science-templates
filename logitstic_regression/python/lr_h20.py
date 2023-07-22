import h2o
from h2o.estimators import H2OGeneralizedLinearEstimator

# Initialize H2O
h2o.init()

# Load the data
data = h2o.import_file("data.csv")

# Split the data into features and labels
features = data.columns[:-1]
labels = data[data.columns[-1]]

# Create a logistic regression model
model = H2OGeneralizedLinearEstimator(family="binomial")

# Fit the model to the data
model.fit(features, labels)

# Predict the labels for the test data
predictions = model.predict(features)

# Evaluate the model
accuracy = model.model_performance(features, labels).accuracy()
print("Accuracy:", accuracy)
