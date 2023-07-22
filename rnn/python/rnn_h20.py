import h2o
from h2o.estimators.deeplearning import H2ODeepLearningEstimator

# Initialize H2O
h2o.init()

# Generate some data
data = [[1,2,3,4,5],[6,7,8,9,10]]

# Convert the data to an H2O Frame
df = h2o.Frame(data)

# Create an H2O Deep Learning Estimator
model = H2ODeepLearningEstimator(
    activation='tanh',
    hidden_units=[10, 10],
    epochs=10,
    nfolds=3,
    seed=1234
)

# Fit the model to the data
model.fit(df)

# Make predictions
predictions = model.predict(df)

# Print the predictions
print(predictions)
