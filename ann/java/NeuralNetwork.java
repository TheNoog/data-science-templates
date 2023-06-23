package ann.java;

import java.util.Arrays;

// For the ActivationFunction class.
// https://github.com/jeffheaton/aifh/blob/master/vol3/vol3-java-examples/src/main/java/com/heatonresearch/aifh/ann/activation/ActivationFunction.java

public class NeuralNetwork {
    private double[][] weights1;
    private double[][] weights2;
    private double[] biases1;
    private double[] biases2;
    private double learningRate;
    private ActivationFunction activation;
    private ActivationFunction derivative;

    public NeuralNetwork(int inputSize, int hiddenSize, int outputSize, double learningRate) {
        this.weights1 = randomMatrix(inputSize, hiddenSize);
        this.weights2 = randomMatrix(hiddenSize, outputSize);
        this.biases1 = randomVector(hiddenSize);
        this.biases2 = randomVector(outputSize);
        this.learningRate = learningRate;
        this.activation = x -> 1 / (1 + Math.exp(-x));
        this.derivative = x -> {
            double sig = activation.apply(x);
            return sig * (1 - sig);
        };
    }

    private double[][] randomMatrix(int rows, int cols) {
        double[][] matrix = new double[rows][cols];
        for (double[] row : matrix) {
            Arrays.setAll(row, i -> Math.random());
        }
        return matrix;
    }

    private double[] randomVector(int size) {
        double[] vector = new double[size];
        Arrays.setAll(vector, i -> Math.random());
        return vector;
    }

    private double[][] multiplyMatrix(double[][] a, double[][] b) {
        int rowsA = a.length;
        int colsA = a[0].length;
        int colsB = b[0].length;
        if (colsA != b.length) {
            throw new IllegalArgumentException("Matrix multiplication error: Incompatible dimensions");
        }

        double[][] result = new double[rowsA][colsB];
        for (int i = 0; i < rowsA; i++) {
            for (int j = 0; j < colsB; j++) {
                double sum = 0;
                for (int k = 0; k < colsA; k++) {
                    sum += a[i][k] * b[k][j];
                }
                result[i][j] = sum;
            }
        }
        return result;
    }

    private double[][] transposeMatrix(double[][] matrix) {
        int rows = matrix.length;
        int cols = matrix[0].length;
        double[][] transposed = new double[cols][rows];
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                transposed[i][j] = matrix[j][i];
            }
        }
        return transposed;
    }

    private double[][] subtractMatrix(double[][] a, double[][] b) {
        int rows = a.length;
        int cols = a[0].length;
        if (rows != b.length || cols != b[0].length) {
            throw new IllegalArgumentException("Matrix subtraction error: Incompatible dimensions");
        }

        double[][] result = new double[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[i][j] = a[i][j] - b[i][j];
            }
        }
        return result;
    }

    private void applyActivation(double[][] matrix, double[] biases, ActivationFunction activation) {
        int rows = matrix.length;
        int cols = matrix[0].length;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                matrix[i][j] = activation.apply(matrix[i][j] + biases[j]);
            }
        }
    }

    private double[][] applyDerivative(double[][] matrix, ActivationFunction derivative) {
        int rows = matrix.length;
        int cols = matrix[0].length;
        double[][] result = new double[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[i][j] = matrix[i][j] * derivative.apply(matrix[i][j]);
            }
        }
        return result;
    }

    private void multiplyMatrixElementwise(double[][] a, double[][] b) {
        int rows = a.length;
        int cols = a[0].length;
        if (rows != b.length || cols != b[0].length) {
            throw new IllegalArgumentException("Matrix elementwise multiplication error: Incompatible dimensions");
        }

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                a[i][j] *= b[i][j];
            }
        }
    }

    private double[] subtractVector(double[] a, double[] b) {
        int size = a.length;
        if (size != b.length) {
            throw new IllegalArgumentException("Vector subtraction error: Incompatible sizes");
        }

        double[] result = new double[size];
        for (int i = 0; i < size; i++) {
            result[i] = a[i] - b[i];
        }
        return result;
    }

    private double[] sumColumns(double[][] matrix) {
        int rows = matrix.length;
        int cols = matrix[0].length;
        double[] sums = new double[cols];
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                sums[i] += matrix[j][i];
            }
        }
        return sums;
    }

    public void train(double[][] X, double[][] y, int epochs) {
        for (int epoch = 0; epoch < epochs; epoch++) {
            // Forward pass
            double[][] hiddenLayer = multiplyMatrix(X, weights1);
            applyActivation(hiddenLayer, biases1, activation);

            double[][] outputLayer = multiplyMatrix(hiddenLayer, weights2);
            applyActivation(outputLayer, biases2, activation);

            // Backpropagation
            double[][] outputLayerError = subtractMatrix(y, outputLayer);
            double[][] outputLayerDelta = applyDerivative(outputLayer, derivative);
            multiplyMatrixElementwise(outputLayerError, outputLayerDelta);
            double[][] hiddenLayerError = multiplyMatrix(outputLayerError, transposeMatrix(weights2));
            double[][] hiddenLayerDelta = applyDerivative(hiddenLayer, derivative);
            multiplyMatrixElementwise(hiddenLayerError, hiddenLayerDelta);

            double[][] hiddenLayerAdjustment = multiplyMatrix(transposeMatrix(X), hiddenLayerError);
            double[][] outputLayerAdjustment = multiplyMatrix(transposeMatrix(hiddenLayer), outputLayerError);

            double[] hiddenLayerBiasAdjustment = sumColumns(hiddenLayerError);
            double[] outputLayerBiasAdjustment = sumColumns(outputLayerError);

            // Update weights and biases
            weights1 = subtractMatrix(weights1, multiplyMatrixByScalar(hiddenLayerAdjustment, learningRate));
            weights2 = subtractMatrix(weights2, multiplyMatrixByScalar(outputLayerAdjustment, learningRate));
            biases1 = subtractVector(biases1, multiplyVectorByScalar(hiddenLayerBiasAdjustment, learningRate));
            biases2 = subtractVector(biases2, multiplyVectorByScalar(outputLayerBiasAdjustment, learningRate));
        }
    }

    public double[][] predict(double[][] X) {
        double[][] hiddenLayer = multiplyMatrix(X, weights1);
        applyActivation(hiddenLayer, biases1, activation);

        double[][] outputLayer = multiplyMatrix(hiddenLayer, weights2);
        applyActivation(outputLayer, biases2, activation);

        return outputLayer;
    }

    public static void main(String[] args) {
        // Example dataset
        double[][] X = {
            {0, 0},
            {0, 1},
            {1, 0},
            {1, 1}
        };
        double[][] y = {
            {0},
            {1},
            {1},
            {0}
        };

        // Create and train the neural network
        NeuralNetwork nn = new NeuralNetwork(2, 4, 1, 0.1);
        int epochs = 1000;
        nn.train(X, y, epochs);

        // Make predictions on new data
        double[][] predictions = nn.predict(X);

        // Print the predictions
        for (double[] prediction : predictions) {
            System.out.printf("Predicted Output: %.4f\n", prediction[0]);
        }
    }
}
