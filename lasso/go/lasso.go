package main

import (
	"fmt"
	"math"
	"math/rand"
)

// Define the number of samples and features
const nSamples = 100
const nFeatures = 20

// Function to calculate the mean squared error
func calculateMeanSquaredError(yTrue, yPred []float64) float64 {
	n := len(yTrue)
	var mse float64
	for i := 0; i < n; i++ {
		diff := yTrue[i] - yPred[i]
		mse += diff * diff
	}
	return mse / float64(n)
}

// Function to perform LASSO regression
func lassoRegression(X [][]float64, y, coefficients []float64, alpha float64) {
	// Maximum number of iterations for coordinate descent
	maxIterations := 100

	// Step size for coordinate descent
	stepSize := 0.01

	nSamples := len(X)
	nFeatures := len(X[0])

	// Initialize the coefficients to zero
	for i := range coefficients {
		coefficients[i] = 0.0
	}

	// Perform coordinate descent
	for iteration := 0; iteration < maxIterations; iteration++ {
		for j := 0; j < nFeatures; j++ {
			// Calculate the gradient for feature j
			var gradient float64
			for i := 0; i < nSamples; i++ {
				var pred float64
				for k := 0; k < nFeatures; k++ {
					if k != j {
						pred += X[i][k] * coefficients[k]
					}
				}
				gradient += (y[i] - pred) * X[i][j]
			}

			// Update the coefficient using LASSO penalty
			if gradient > alpha {
				coefficients[j] = (gradient - alpha) * stepSize
			} else if gradient < -alpha {
				coefficients[j] = (gradient + alpha) * stepSize
			} else {
				coefficients[j] = 0.0
			}
		}
	}
}

// Generate some synthetic data
func generateSyntheticData() ([][]float64, []float64) {
	X := make([][]float64, nSamples)
	y := make([]float64, nSamples)
	rng := rand.New(rand.NewSource(42))

	for i := 0; i < nSamples; i++ {
		X[i] = make([]float64, nFeatures)
		for j := 0; j < nFeatures; j++ {
			X[i][j] = rng.Float64()
		}

		y[i] = 0.0
		for j := 0; j < nFeatures; j++ {
			y[i] += X[i][j] * float64(j+1)
		}
		y[i] += 0.1 * rng.Float64()
	}

	return X, y
}

func main() {
	// Generate some synthetic data
	X, y := generateSyntheticData()

	// Split the data into training and test sets
	nTrainSamples := int(float64(nSamples) * 0.8)
	nTestSamples := nSamples - nTrainSamples
	XTrain := X[:nTrainSamples]
	yTrain := y[:nTrainSamples]
	XTest := X[nTrainSamples:]
	yTest := y[nTrainSamples:]

	// Perform LASSO regression
	alpha := 0.1
	coefficients := make([]float64, nFeatures)
	lassoRegression(XTrain, yTrain, coefficients, alpha)

	// Make predictions on the test set
	yPred := make([]float64, nTestSamples)
	for i, sample := range XTest {
		for j := 0; j < nFeatures; j++ {
			yPred[i] += sample[j] * coefficients[j]
		}
	}

	// Calculate the mean squared error
	mse := calculateMeanSquaredError(yTest, yPred)
	fmt.Printf("Mean Squared Error: %.4f\n", mse)

	// Print the true coefficients and the estimated coefficients
	fmt.Printf("True Coefficients: [1.0 ")
	for i := 1; i < nFeatures; i++ {
		fmt.Printf("%.4f ", float64(i+1))
	}
	fmt.Printf("]\n")

	fmt.Printf("Estimated Coefficients: [")
	for _, coeff := range coefficients {
		fmt.Printf("%.4f ", coeff)
	}
	fmt.Printf("]\n")
}
