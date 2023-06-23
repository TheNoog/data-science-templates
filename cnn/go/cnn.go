package main

import (
	"fmt"
	"math"
	"math/rand"
)

type HiddenLayer struct {
	Weights [][]float64
	Bias    []float64
}

type OutputLayer struct {
	Weights [][]float64
	Bias    []float64
}

const (
	InputSize    = 64
	HiddenSize   = 128
	OutputSize   = 10
	LearningRate = 0.01
	Epochs       = 10
)

func sigmoid(x float64) float64 {
	return 1.0 / (1.0 + math.Exp(-x))
}

func initializeWeights(hiddenSize, inputSize int) *HiddenLayer {
	weights := make([][]float64, hiddenSize)
	bias := make([]float64, hiddenSize)

	for i := 0; i < hiddenSize; i++ {
		weights[i] = make([]float64, inputSize)
		for j := 0; j < inputSize; j++ {
			weights[i][j] = rand.Float64() - 0.5
		}
		bias[i] = rand.Float64() - 0.5
	}

	return &HiddenLayer{Weights: weights, Bias: bias}
}

func initializeOutputWeights(outputSize, hiddenSize int) *OutputLayer {
	weights := make([][]float64, outputSize)
	bias := make([]float64, outputSize)

	for i := 0; i < outputSize; i++ {
		weights[i] = make([]float64, hiddenSize)
		for j := 0; j < hiddenSize; j++ {
			weights[i][j] = rand.Float64() - 0.5
		}
		bias[i] = rand.Float64() - 0.5
	}

	return &OutputLayer{Weights: weights, Bias: bias}
}

func forwardPropagation(input []float64, hiddenLayer *HiddenLayer, outputLayer *OutputLayer) []float64 {
	hiddenOutput := make([]float64, HiddenSize)

	for i := 0; i < HiddenSize; i++ {
		sum := hiddenLayer.Bias[i]

		for j := 0; j < InputSize; j++ {
			sum += input[j] * hiddenLayer.Weights[i][j]
		}

		hiddenOutput[i] = sigmoid(sum)
	}

	output := make([]float64, OutputSize)

	for i := 0; i < OutputSize; i++ {
		sum := outputLayer.Bias[i]

		for j := 0; j < HiddenSize; j++ {
			sum += hiddenOutput[j] * outputLayer.Weights[i][j]
		}

		output[i] = sigmoid(sum)
	}

	return output
}

func backPropagation(input, target []float64, hiddenLayer *HiddenLayer, outputLayer *OutputLayer) {
	hiddenOutput := make([]float64, HiddenSize)
	output := forwardPropagation(input, hiddenLayer, outputLayer)

	outputDelta := make([]float64, OutputSize)
	hiddenDelta := make([]float64, HiddenSize)

	for i := 0; i < OutputSize; i++ {
		outputDelta[i] = (output[i] - target[i]) * output[i] * (1 - output[i])
	}

	for i := 0; i < HiddenSize; i++ {
		error := 0.0

		for j := 0; j < OutputSize; j++ {
			error += outputLayer.Weights[j][i] * outputDelta[j]
		}

		hiddenDelta[i] = error * hiddenOutput[i] * (1 - hiddenOutput[i])
	}

	for i := 0; i < OutputSize; i++ {
		for j := 0; j < HiddenSize; j++ {
			outputLayer.Weights[i][j] -= LearningRate * outputDelta[i] * hiddenOutput[j]
		}

		outputLayer.Bias[i] -= LearningRate * outputDelta[i]
	}

	for i := 0; i < HiddenSize; i++ {
		for j := 0; j < InputSize; j++ {
			hiddenLayer.Weights[i][j] -= LearningRate * hiddenDelta[i] * input[j]
		}

		hiddenLayer.Bias[i] -= LearningRate * hiddenDelta[i]
	}
}

func main() {
	input := []float64{ /* Input values here */ }
	target := []float64{ /* Target values here */ }

	hiddenLayer := initializeWeights(HiddenSize, InputSize)
	outputLayer := initializeOutputWeights(OutputSize, HiddenSize)

	for epoch := 0; epoch < Epochs; epoch++ {
		backPropagation(input, target, hiddenLayer, outputLayer)
	}

	output := forwardPropagation(input, hiddenLayer, outputLayer)

	fmt.Println("Output:", output)
}
