using TensorFlow

function createModel()
    model = TensorFlow.keras.Sequential()
    add!(model, TensorFlow.keras.layers.Dense(4, activation="sigmoid", input_dim=2))
    add!(model, TensorFlow.keras.layers.Dense(1, activation="sigmoid"))
    return model
end

function trainModel(model, inputs, targets, learning_rate, epochs)
    optimizer = TensorFlow.keras.optimizers.SGD(learning_rate)
    loss_fn = TensorFlow.keras.losses.MeanSquaredError()

    for epoch in 1:epochs
        grads = TensorFlow.GradientTape() do tape
            predictions = TensorFlow.predict(model, inputs)
            loss_value = loss_fn(targets, predictions)
            grads = TensorFlow.gradient(tape, loss_value, TensorFlow.trainable_variables(model))
        end

        TensorFlow.apply_gradients(optimizer, grads)
    end
end

function main()
    # Training data
    inputs = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
    targets = [[0.0], [1.0], [1.0], [0.0]]

    # Hyperparameters
    learning_rate = 0.1
    epochs = 1000

    # Convert data to TensorFlow tensors
    inputs = TensorFlow.constant(inputs)
    targets = TensorFlow.constant(targets)

    # Create and train the model
    model = createModel()
    trainModel(model, inputs, targets, learning_rate, epochs)

    # Test the trained model
    predictions = TensorFlow.predict(model, inputs)
    for i in 1:size(inputs)[1]
        println("Input: $(inputs[i, :]), Predicted Output: $(predictions[i, 1])")
    end
end

main()
