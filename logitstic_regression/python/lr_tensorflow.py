import tensorflow as tf

# Load the data
data = tf.keras.datasets.mnist.load_data()

# Split the data into features and labels
features = data["x_train"]
labels = data["y_train"]

# Create a logistic regression model
model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),
  tf.keras.layers.Dense(128, activation="relu"),
  tf.keras.layers.Dense(10, activation="softmax")
])

# Compile the model
model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])

# Fit the model to the data
model.fit(features, labels, epochs=10)

# Predict the labels for the test data
predictions = model.predict(features)

# Evaluate the model
accuracy = tf.metrics.accuracy(labels, predictions)
print("Accuracy:", accuracy)
