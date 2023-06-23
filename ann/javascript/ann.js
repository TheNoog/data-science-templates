class NeuralNetwork {
    constructor(inputSize, hiddenSize, outputSize, learningRate) {
      this.weights1 = this.randomMatrix(inputSize, hiddenSize);
      this.weights2 = this.randomMatrix(hiddenSize, outputSize);
      this.biases1 = this.randomVector(hiddenSize);
      this.biases2 = this.randomVector(outputSize);
      this.learningRate = learningRate;
      this.activation = x => 1 / (1 + Math.exp(-x));
      this.derivative = x => {
        const sig = this.activation(x);
        return sig * (1 - sig);
      };
    }
  
    randomMatrix(rows, cols) {
      return Array.from({ length: rows }, () =>
        Array.from({ length: cols }, () => Math.random())
      );
    }
  
    randomVector(size) {
      return Array.from({ length: size }, () => Math.random());
    }
  
    multiplyMatrix(a, b) {
      const rowsA = a.length;
      const colsA = a[0].length;
      const colsB = b[0].length;
      if (colsA !== b.length) {
        throw new Error("Matrix multiplication error: Incompatible dimensions");
      }
  
      const result = Array.from({ length: rowsA }, () =>
        Array.from({ length: colsB }, () => 0)
      );
  
      for (let i = 0; i < rowsA; i++) {
        for (let j = 0; j < colsB; j++) {
          let sum = 0;
          for (let k = 0; k < colsA; k++) {
            sum += a[i][k] * b[k][j];
          }
          result[i][j] = sum;
        }
      }
  
      return result;
    }
  
    transposeMatrix(matrix) {
      const rows = matrix.length;
      const cols = matrix[0].length;
      const transposed = Array.from({ length: cols }, () =>
        Array.from({ length: rows }, () => 0)
      );
  
      for (let i = 0; i < cols; i++) {
        for (let j = 0; j < rows; j++) {
          transposed[i][j] = matrix[j][i];
        }
      }
  
      return transposed;
    }
  
    subtractMatrix(a, b) {
      const rows = a.length;
      const cols = a[0].length;
      if (rows !== b.length || cols !== b[0].length) {
        throw new Error("Matrix subtraction error: Incompatible dimensions");
      }
  
      const result = Array.from({ length: rows }, () =>
        Array.from({ length: cols }, () => 0)
      );
  
      for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
          result[i][j] = a[i][j] - b[i][j];
        }
      }
  
      return result;
    }
  
    applyActivation(matrix, biases, activation) {
      const rows = matrix.length;
      const cols = matrix[0].length;
  
      for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
          matrix[i][j] = activation(matrix[i][j] + biases[j]);
        }
      }
    }
  
    applyDerivative(matrix, derivative) {
      const rows = matrix.length;
      const cols = matrix[0].length;
      const result = Array.from({ length: rows }, () =>
        Array.from({ length: cols }, () => 0)
      );
  
      for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
          result[i][j] = matrix[i][j] * derivative(matrix[i][j]);
        }
      }
  
      return result;
    }
  
    multiplyMatrixElementwise(a, b) {
      const rows = a.length;
      const cols = a[0].length;
      if (rows !== b.length || cols !== b[0].length) {
        throw new Error("Matrix elementwise multiplication error: Incompatible dimensions");
      }
  
      for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
          a[i][j] *= b[i][j];
        }
      }
    }
  
    subtractVector(a, b) {
      const size = a.length;
      if (size !== b.length) {
        throw new Error("Vector subtraction error: Incompatible sizes");
      }
  
      const result = Array.from({ length: size }, () => 0);
      for (let i = 0; i < size; i++) {
        result[i] = a[i] - b[i];
      }
      return result;
    }
  
    sumColumns(matrix) {
      const rows = matrix.length;
      const cols = matrix[0].length;
      const sums = Array.from({ length: cols }, () => 0);
  
      for (let i = 0; i < cols; i++) {
        for (let j = 0; j < rows; j++) {
          sums[i] += matrix[j][i];
        }
      }
  
      return sums;
    }
  
    train(X, y, epochs) {
      for (let epoch = 0; epoch < epochs; epoch++) {
        // Forward pass
        const hiddenLayer = this.multiplyMatrix(X, this.weights1);
        this.applyActivation(hiddenLayer, this.biases1, this.activation);
  
        const outputLayer = this.multiplyMatrix(hiddenLayer, this.weights2);
        this.applyActivation(outputLayer, this.biases2, this.activation);
  
        // Backpropagation
        const outputLayerError = this.subtractMatrix(y, outputLayer);
        const outputLayerDelta = this.applyDerivative(outputLayer, this.derivative);
        this.multiplyMatrixElementwise(outputLayerError, outputLayerDelta);
  
        const hiddenLayerError = this.multiplyMatrix(outputLayerError, this.transposeMatrix(this.weights2));
        const hiddenLayerDelta = this.applyDerivative(hiddenLayer, this.derivative);
        this.multiplyMatrixElementwise(hiddenLayerError, hiddenLayerDelta);
  
        const hiddenLayerAdjustment = this.multiplyMatrix(this.transposeMatrix(X), hiddenLayerError);
        const outputLayerAdjustment = this.multiplyMatrix(this.transposeMatrix(hiddenLayer), outputLayerError);
  
        const hiddenLayerBiasAdjustment = this.sumColumns(hiddenLayerError);
        const outputLayerBiasAdjustment = this.sumColumns(outputLayerError);
  
        // Update weights and biases
        this.weights1 = this.subtractMatrix(this.weights1, this.multiplyMatrixByScalar(hiddenLayerAdjustment, this.learningRate));
        this.weights2 = this.subtractMatrix(this.weights2, this.multiplyMatrixByScalar(outputLayerAdjustment, this.learningRate));
        this.biases1 = this.subtractVector(this.biases1, this.multiplyVectorByScalar(hiddenLayerBiasAdjustment, this.learningRate));
        this.biases2 = this.subtractVector(this.biases2, this.multiplyVectorByScalar(outputLayerBiasAdjustment, this.learningRate));
      }
    }
  
    predict(X) {
      const hiddenLayer = this.multiplyMatrix(X, this.weights1);
      this.applyActivation(hiddenLayer, this.biases1, this.activation);
  
      const outputLayer = this.multiplyMatrix(hiddenLayer, this.weights2);
      this.applyActivation(outputLayer, this.biases2, this.activation);
  
      return outputLayer;
    }
  }
  
  // Example usage
  const X = [
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1]
  ];
  const y = [
    [0],
    [1],
    [1],
    [0]
  ];
  
  const nn = new NeuralNetwork(2, 4, 1, 0.1);
  const epochs = 1000;
  nn.train(X, y, epochs);
  
  const predictions = nn.predict(X);
  predictions.forEach(prediction => {
    console.log(`Predicted Output: ${prediction[0].toFixed(4)}`);
  });
  