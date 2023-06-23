import tensorflow as tf
import numpy as np

# Example dataset
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])

# Define the model
model = tf.keras.models.Sequential([
    tf.keras.layers.Dense(4, input_shape=(2,), activation='relu'),
    tf.keras.layers.Dense(1, activation='sigmoid')
])

# Compile the model
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Train the model
model.fit(X, y, epochs=1000, batch_size=4, verbose=0)

# Make predictions on new data
predictions = model.predict(X)

# Print the predictions
for i in range(len(predictions)):
    print(f"Input: {X[i]}, Predicted Output: {predictions[i]}")
