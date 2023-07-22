function rnn = RNN(inputDim, hiddenDim, outputDim)

  % Initialize weights and biases
  weights = rand(inputDim, hiddenDim) - 0.5;
  biases = rand(hiddenDim) - 0.5;

  % Initialize hidden state
  h = zeros(hiddenDim, 1);

end

function rnn = train(rnn, data)

  % Train the RNN model
  for sequence in data

    for t in sequence

      % Compute the hidden state
      z = 0;
      for i in 1:inputDim
        z += data(t, i) * weights(i, h(end));
      end
      h = [h tanh(z + biases(end))];
    end

  end

end

function predictions = predict(rnn, data)

  % Make predictions on the given data
  predictions = [];
  h = zeros(hiddenDim, 1);
  for t in data

    % Compute the hidden state
    z = 0;
    for i in 1:inputDim
      z += data(t, i) * weights(i, h(end));
    end
    h = [h tanh(z + biases(end))];

    % Add the prediction to the list of predictions
    predictions = [predictions h(end)];
  end

  return predictions;

end
