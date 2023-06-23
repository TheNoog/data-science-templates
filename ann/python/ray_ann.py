import numpy as np
import ray
import tensorflow as tf

# Initialize Ray
ray.init()

@ray.remote
class NeuralNetwork:
    def __init__(self):
        self.model = self.build_model()

    def build_model(self):
        model = tf.keras.models.Sequential([
            tf.keras.layers.Dense(4, input_shape=(2,), activation='relu'),
            tf.keras.layers.Dense(1, activation='sigmoid')
        ])
        model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
        return model

    def train(self, X, y, epochs, batch_size):
        self.model.fit(X, y, epochs=epochs, batch_size=batch_size, verbose=0)

    def predict(self, X):
        return self.model.predict(X)

# Example dataset
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])

# Create remote neural network actors
actors = [NeuralNetwork.remote() for _ in range(ray.cluster_resources()["CPU"])]

# Train the neural networks in parallel
ray.get([actor.train.remote(X, y, epochs=1000, batch_size=4) for actor in actors])

# Make predictions on new data
predictions = ray.get([actor.predict.remote(X) for actor in actors])

# Print the predictions
for i in range(len(predictions[0])):
    print(f"Input: {X[i]}, Predicted Output: {predictions[0][i]}")
