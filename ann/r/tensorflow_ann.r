library(tensorflow)

# Load data
data <- read.csv("data.csv")

# Split data into training and validation sets
train_indices <- sample(nrow(data), nrow(data) * 0.8)
train_data <- data[train_indices, ]
valid_data <- data[-train_indices, ]

# Define the features and target column
features <- colnames(data)[1:(ncol(data)-1)]
target <- colnames(data)[ncol(data)]

# Create a TensorFlow session
sess <- tf$Session()

# Define the input placeholders
input <- tf$placeholder(tf$float32, shape(NULL, length(features)), name = "input")
output <- tf$placeholder(tf$float32, shape(NULL, 1), name = "output")

# Define the neural network architecture
hidden_size <- 10
hidden_layer <- tf$layers$dense(input, units = hidden_size, activation = "relu")
output_layer <- tf$layers$dense(hidden_layer, units = 1, activation = "sigmoid")

# Define the loss function
loss <- tf$losses$mean_squared_error(output, output_layer)

# Define the optimizer
optimizer <- tf$train$AdamOptimizer(learning_rate = 0.01)
train_op <- optimizer$minimize(loss)

# Initialize variables
sess$run(tf$global_variables_initializer())

# Train the neural network
epochs <- 100
batch_size <- 32

for (epoch in 1:epochs) {
  # Shuffle the training data
  shuffled_indices <- sample(nrow(train_data))
  shuffled_data <- train_data[shuffled_indices, ]
  
  # Perform mini-batch training
  for (i in seq(1, nrow(train_data), batch_size)) {
    batch <- shuffled_data[i:(i + batch_size - 1), ]
    feed_dict <- dict(
      input = as.matrix(batch[, features]),
      output = as.matrix(batch[, target])
    )
    sess$run(train_op, feed_dict = feed_dict)
  }
}

# Evaluate the model on the validation set
feed_dict_valid <- dict(
  input = as.matrix(valid_data[, features]),
  output = as.matrix(valid_data[, target])
)
valid_loss <- sess$run(loss, feed_dict = feed_dict_valid)
print(paste("Validation loss:", valid_loss))

# Close the TensorFlow session
sess$close()
