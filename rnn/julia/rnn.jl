using Flux, RNN

# Generate some data
data = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]

# Create a RNN model
model = RNN(10, 20, 10)

# Fit the model to the data
model.train!(data, epochs=10)

# Make predictions
predictions = model(data)

# Print the predictions
println(predictions)
