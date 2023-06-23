library(h2o)

# Initialize H2O
h2o.init()

# Load data
data <- h2o.importFile("data.csv")

# Split data into training and validation sets
split <- h2o.splitFrame(data, ratios = c(0.8), seed = 123)
train <- split[[1]]
valid <- split[[2]]

# Define the features and target column
features <- colnames(data)[1:(ncol(data)-1)]
target <- colnames(data)[ncol(data)]

# Train the neural network model
model <- h2o.deeplearning(x = features, y = target, training_frame = train, validation_frame = valid,
                          hidden = c(10, 10), epochs = 100)

# Make predictions
predictions <- h2o.predict(model, valid)

# Evaluate the model
performance <- h2o.performance(model, valid = TRUE)
print(performance)

# Shutdown H2O
h2o.shutdown()
