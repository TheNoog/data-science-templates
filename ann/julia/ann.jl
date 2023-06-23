using Flux
using Flux: onehotbatch, logitcrossentropy, throttle

# Example dataset
X = [[0, 0], [0, 1], [1, 0], [1, 1]]
y = [0, 1, 1, 0]

# Convert labels to one-hot encoded vectors
labels = onehotbatch(y, 0:1)

# Create a model
model = Chain(
    Dense(2, 4, relu),
    Dense(4, 1, sigmoid)
)

# Define the loss function
loss(x, y) = logitcrossentropy(model(x), y)

# Define the optimizer
optimizer = ADAM()

# Training loop
for epoch in 1:1000
    Flux.train!(loss, params(model), [(X, labels)], optimizer)
end

# Make predictions on new data
predictions = model(X)

# Print the predictions
for i in 1:length(predictions)
    println("Input: ", X[i], ", Predicted Output: ", predictions[i])
end
