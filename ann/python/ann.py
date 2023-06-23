import numpy as np
from keras.models import Sequential
from keras.layers import Dense

# Example dataset
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])

# Create a Sequential model
model = Sequential()

# Add input layer and hidden layer with 4 neurons and 'relu' activation
model.add(Dense(4, input_dim=2, activation='relu'))

# Add output layer with 1 neuron and 'sigmoid' activation
model.add(Dense(1, activation='sigmoid'))

# Compile the model with binary cross-entropy loss and Adam optimizer
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# Fit the model to the training data
model.fit(X, y, epochs=1000, batch_size=4, verbose=0)

# Make predictions on new data
predictions = model.predict(X)

# Print the predictions
for i in range(len(predictions)):
    print(f"Input: {X[i]}, Predicted Output: {predictions[i]}")
