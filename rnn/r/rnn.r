library(keras)

# Define the RNN model
model <- keras_model_sequential()
model %>%
    layer_simple_rnn(units=100) %>%
    layer_dense(units=10, activation="softmax")

# Compile the model
model %>% compile(
    loss="categorical_crossentropy",
    optimizer="adam",
    metrics=c("accuracy")
)

# Load the training data
data <- read_csv("data.csv")

# Split the data into train and test sets
train_x <- data[, 1:(ncol(data) - 1)]
train_y <- data[, ncol(data)]
test_x <- data[, 1:(ncol(data) - 1)]
test_y <- data[, ncol(data)]

# Train the model
model %>% fit(
    train_x,
    train_y,
    epochs=10,
    batch_size=128,
    validation_data=(test_x, test_y)
)

# Evaluate the model on the test set
score <- model %>% evaluate(test_x, test_y)
print(score)
