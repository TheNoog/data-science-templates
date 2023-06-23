import h2o
from h2o.estimators import H2ODeepLearningEstimator

# Initialize H2O
h2o.init()

# Load the data into H2O
train_data = h2o.import_file("train_data.csv")
test_data = h2o.import_file("test_data.csv")

# Define the CNN model
model = H2ODeepLearningEstimator(
    epochs=10,
    activation="Rectifier",
    hidden=[32, 64, 128],
    input_dropout_ratio=0.2,
    sparse=True
)

# Train the model
model.train(x=train_data.columns[:-1], y=train_data.columns[-1], training_frame=train_data)

# Evaluate the model
performance = model.model_performance(test_data)

# Print the model performance
print(performance)

# Shutdown H2O
h2o.shutdown()
