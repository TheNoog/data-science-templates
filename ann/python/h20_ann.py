import h2o

# Initialize H2O
h2o.init()

# Load data
data = h2o.import_file("data.csv")

# Split data into training and validation sets
train, valid = data.split_frame(ratios=[0.8])

# Define the features and target column
features = data.col_names[:-1]
target = data.col_names[-1]

# Train the neural network model
model = H2ODeepLearningEstimator(hidden=[10, 10], epochs=100)
model.train(x=features, y=target, training_frame=train, validation_frame=valid)

# Make predictions
predictions = model.predict(valid)

# Evaluate the model
performance = model.model_performance(valid)
print(performance)

# Shutdown H2O
h2o.shutdown()
