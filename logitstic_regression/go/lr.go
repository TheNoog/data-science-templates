package main

import (
    "fmt"
    "math"
)

type LogisticRegression struct {
    weights []float64
    bias float64
}

func (model *LogisticRegression) Train(features []float64, label int) {
    prediction := sigmoid(dot(features, model.weights) + model.bias)
    error := float64(label) - prediction

    for i, feature := range features {
        model.weights[i] += error * feature
    }
    model.bias += error
}

func (model *LogisticRegression) Predict(features []float64) int {
    return int(sigmoid(dot(features, model.weights) + model.bias) > 0.5)
}

func sigmoid(x float64) float64 {
    return 1.0 / (1.0 + math.Exp(-x))
}

func dot(features []float64, weights []float64) float64 {
    sum := 0.0
    for i, feature := range features {
        sum += feature * weights[i]
    }
    return sum
}

func main() {
    features := []float64{1.0, 2.0}
    label := 1

    model := LogisticRegression{
        weights: make([]float64, len(features)),
        bias: 0.0,
    }

    for i := 0; i < 100; i++ {
        model.Train(features, label)
    }

    newFeatures := []float64{3.0, 4.0}
    newLabel := model.Predict(newFeatures)

    fmt.Println("The predicted label is", newLabel)
}
