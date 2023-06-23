class HiddenLayer {
    constructor(hiddenSize, inputSize) {
      this.weights = [];
      this.bias = [];
  
      for (let i = 0; i < hiddenSize; i++) {
        this.weights[i] = [];
        for (let j = 0; j < inputSize; j++) {
          this.weights[i][j] = Math.random() - 0.5;
        }
        this.bias[i] = Math.random() - 0.5;
      }
    }
  }
  
  class OutputLayer {
    constructor(outputSize, hiddenSize) {
      this.weights = [];
      this.bias = [];
  
      for (let i = 0; i < outputSize; i++) {
        this.weights[i] = [];
        for (let j = 0; j < hiddenSize; j++) {
          this.weights[i][j] = Math.random() - 0.5;
        }
        this.bias[i] = Math.random() - 0.5;
      }
    }
  }
  
  const InputSize = 64;
  const HiddenSize = 128;
  const OutputSize = 10;
  const LearningRate = 0.01;
  const Epochs = 10;
  
  function sigmoid(x) {
    return 1.0 / (1.0 + Math.exp(-x));
  }
  
  function forwardPropagation(input, hiddenLayer, outputLayer) {
    const hiddenOutput = [];
  
    for (let i = 0; i < HiddenSize; i++) {
      let sum = hiddenLayer.bias[i];
  
      for (let j = 0; j < InputSize; j++) {
        sum += input[j] * hiddenLayer.weights[i][j];
      }
  
      hiddenOutput[i] = sigmoid(sum);
    }
  
    const output = [];
  
    for (let i = 0; i < OutputSize; i++) {
      let sum = outputLayer.bias[i];
  
      for (let j = 0; j < HiddenSize; j++) {
        sum += hiddenOutput[j] * outputLayer.weights[i][j];
      }
  
      output[i] = sigmoid(sum);
    }
  
    return output;
  }
  
  function backPropagation(input, target, hiddenLayer, outputLayer) {
    const hiddenOutput = [];
    const output = forwardPropagation(input, hiddenLayer, outputLayer);
  
    const outputDelta = [];
    const hiddenDelta = [];
  
    for (let i = 0; i < OutputSize; i++) {
      outputDelta[i] = (output[i] - target[i]) * output[i] * (1 - output[i]);
    }
  
    for (let i = 0; i < HiddenSize; i++) {
      let error = 0.0;
  
      for (let j = 0; j < OutputSize; j++) {
        error += outputLayer.weights[j][i] * outputDelta[j];
      }
  
      hiddenDelta[i] = error * hiddenOutput[i] * (1 - hiddenOutput[i]);
    }
  
    for (let i = 0; i < OutputSize; i++) {
      for (let j = 0; j < HiddenSize; j++) {
        outputLayer.weights[i][j] -= LearningRate * outputDelta[i] * hiddenOutput[j];
      }
  
      outputLayer.bias[i] -= LearningRate * outputDelta[i];
    }
  
    for (let i = 0; i < HiddenSize; i++) {
      for (let j = 0; j < InputSize; j++) {
        hiddenLayer.weights[i][j] -= LearningRate * hiddenDelta[i] * input[j];
      }
  
      hiddenLayer.bias[i] -= LearningRate * hiddenDelta[i];
    }
  }
  
  const input = [/* Input values here */];
  const target = [/* Target values here */];
  
  const hiddenLayer = new HiddenLayer(HiddenSize, InputSize);
  const outputLayer = new OutputLayer(OutputSize, HiddenSize);
  
  for (let epoch = 0; epoch < Epochs; epoch++) {
    backPropagation(input, target, hiddenLayer, outputLayer);
  }
  
  const output = forwardPropagation(input, hiddenLayer, outputLayer);
  
  console.log("Output:", output);
  