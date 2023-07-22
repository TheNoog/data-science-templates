import tensorflow as tf

class RNN(tf.keras.Model):

    def __init__(self, input_dim, hidden_dim, output_dim):
        super(RNN, self).__init__()

        self.input_dim = input_dim
        self.hidden_dim = hidden_dim
        self.output_dim = output_dim

        self.lstm = tf.keras.layers.LSTM(self.hidden_dim)
        self.dense = tf.keras.layers.Dense(self.output_dim)

    def call(self, inputs):
        x = self.lstm(inputs)
        x = self.dense(x)
        return x

model = RNN(input_dim=10, hidden_dim=20, output_dim=10)

# Generate some data
data = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]

# Train the model
model.compile(optimizer='adam', loss='mse')
model.fit(data, epochs=10)

# Make predictions
predictions = model.predict(data)

print(predictions)
