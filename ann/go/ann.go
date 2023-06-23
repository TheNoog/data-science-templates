package main

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

// NeuralNetwork represents the ANN model
type NeuralNetwork struct {
	weights1     [][]float64
	weights2     [][]float64
	biases1      []float64
	biases2      []float64
	learningRate float64
	activation   func(float64) float64
	derivative   func(float64) float64
}

// NewNeuralNetwork creates a new instance of NeuralNetwork
func NewNeuralNetwork(inputSize, hiddenSize, outputSize int, learningRate float64) *NeuralNetwork {
	nn := NeuralNetwork{
		weights1:     randomMatrix(inputSize, hiddenSize),
		weights2:     randomMatrix(hiddenSize, outputSize),
		biases1:      randomVector(hiddenSize),
		biases2:      randomVector(outputSize),
		learningRate: learningRate,
		activation:   sigmoid,
		derivative:   sigmoidDerivative,
	}
	return &nn
}

// randomMatrix creates a random matrix of given size
func randomMatrix(rows, cols int) [][]float64 {
	matrix := make([][]float64, rows)
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < rows; i++ {
		matrix[i] = randomVector(cols)
	}
	return matrix
}

// randomVector creates a random vector of given size
func randomVector(size int) []float64 {
	vector := make([]float64, size)
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < size; i++ {
		vector[i] = rand.Float64()
	}
	return vector
}

// sigmoid applies the sigmoid activation function
func sigmoid(x float64) float64 {
	return 1.0 / (1.0 + math.Exp(-x))
}

// sigmoidDerivative computes the derivative of sigmoid function
func sigmoidDerivative(x float64) float64 {
	sig := sigmoid(x)
	return sig * (1.0 - sig)
}

// Train trains the neural network using backpropagation
func (nn *NeuralNetwork) Train(X, y [][]float64, epochs int) {
	for epoch := 0; epoch < epochs; epoch++ {
		// Forward pass
		hiddenLayer := multiplyMatrix(X, nn.weights1)
		applyActivation(hiddenLayer, nn.biases1, nn.activation)
		outputLayer := multiplyMatrix(hiddenLayer, nn.weights2)
		applyActivation(outputLayer, nn.biases2, nn.activation)

		// Backpropagation
		outputError := subtractMatrix(outputLayer, y)
		outputDelta := applyDerivative(outputLayer, nn.derivative)
		multiplyMatrixElementwise(outputError, outputDelta)
		hiddenError := multiplyMatrix(outputDelta, transposeMatrix(nn.weights2))
		hiddenDelta := applyDerivative(hiddenLayer, nn.derivative)
		multiplyMatrixElementwise(hiddenError, hiddenDelta)

		// Update weights and biases
		nn.weights2 = subtractMatrix(nn.weights2, multiplyMatrix(transposeMatrix(hiddenLayer), outputDelta).multiplyScalar(nn.learningRate))
		nn.biases2 = subtractVector(nn.biases2, sumColumns(outputDelta).multiplyScalar(nn.learningRate))
		nn.weights1 = subtractMatrix(nn.weights1, multiplyMatrix(transposeMatrix(X), hiddenDelta).multiplyScalar(nn.learningRate))
		nn.biases1 = subtractVector(nn.biases1, sumColumns(hiddenDelta).multiplyScalar(nn.learningRate))
	}
}

// Predict makes predictions using the trained neural network
func (nn *NeuralNetwork) Predict(X [][]float64) [][]float64 {
	hiddenLayer := multiplyMatrix(X, nn.weights1)
	applyActivation(hiddenLayer, nn.biases1, nn.activation)
	outputLayer := multiplyMatrix(hiddenLayer, nn.weights2)
	applyActivation(outputLayer, nn.biases2, nn.activation)
	return outputLayer
}

// Helper functions for matrix operations

func multiplyMatrix(a, b [][]float64) [][]float64 {
	rowsA, colsA := len(a), len(a[0])
	rowsB, colsB := len(b), len(b[0])
	if colsA != rowsB {
		panic("Matrix multiplication error: Incompatible dimensions")
	}

	result := make([][]float64, rowsA)
	for i := 0; i < rowsA; i++ {
		result[i] = make([]float64, colsB)
		for j := 0; j < colsB; j++ {
			sum := 0.0
			for k := 0; k < colsA; k++ {
				sum += a[i][k] * b[k][j]
			}
			result[i][j] = sum
		}
	}
	return result
}

func transposeMatrix(matrix [][]float64) [][]float64 {
	rows, cols := len(matrix), len(matrix[0])
	transposed := make([][]float64, cols)
	for i := 0; i < cols; i++ {
		transposed[i] = make([]float64, rows)
		for j := 0; j < rows; j++ {
			transposed[i][j] = matrix[j][i]
		}
	}
	return transposed
}

func subtractMatrix(a, b [][]float64) [][]float64 {
	rows, cols := len(a), len(a[0])
	if rows != len(b) || cols != len(b[0]) {
		panic("Matrix subtraction error: Incompatible dimensions")
	}

	result := make([][]float64, rows)
	for i := 0; i < rows; i++ {
		result[i] = make([]float64, cols)
		for j := 0; j < cols; j++ {
			result[i][j] = a[i][j] - b[i][j]
		}
	}
	return result
}

func applyActivation(matrix [][]float64, biases []float64, activation func(float64) float64) {
	rows, cols := len(matrix), len(matrix[0])
	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			matrix[i][j] = activation(matrix[i][j] + biases[j])
		}
	}
}

func applyDerivative(matrix [][]float64, derivative func(float64) float64) [][]float64 {
	rows, cols := len(matrix), len(matrix[0])
	result := make([][]float64, rows)
	for i := 0; i < rows; i++ {
		result[i] = make([]float64, cols)
		for j := 0; j < cols; j++ {
			result[i][j] = matrix[i][j] * derivative(matrix[i][j])
		}
	}
	return result
}

func multiplyMatrixElementwise(a, b [][]float64) {
	rows, cols := len(a), len(a[0])
	if rows != len(b) || cols != len(b[0]) {
		panic("Matrix elementwise multiplication error: Incompatible dimensions")
	}

	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			a[i][j] *= b[i][j]
		}
	}
}

func subtractVector(a, b []float64) []float64 {
	size := len(a)
	if size != len(b) {
		panic("Vector subtraction error: Incompatible sizes")
	}

	result := make([]float64, size)
	for i := 0; i < size; i++ {
		result[i] = a[i] - b[i]
	}
	return result
}

func sumColumns(matrix [][]float64) []float64 {
	rows, cols := len(matrix), len(matrix[0])
	sums := make([]float64, cols)
	for i := 0; i < cols; i++ {
		for j := 0; j < rows; j++ {
			sums[i] += matrix[j][i]
		}
	}
	return sums
}

func main() {
	// Example dataset
	X := [][]float64{
		{0, 0},
		{0, 1},
		{1, 0},
		{1, 1},
	}
	y := [][]float64{
		{0},
		{1},
		{1},
		{0},
	}

	// Create and train the neural network
	nn := NewNeuralNetwork(2, 4, 1, 0.1)
	epochs := 1000
	nn.Train(X, y, epochs)

	// Make predictions on new data
	predictions := nn.Predict(X)

	// Print the predictions
	for i := range predictions {
		fmt.Printf("Predicted Output: %f\n", predictions[i][0])
	}
}
