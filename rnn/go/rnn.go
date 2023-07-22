package main

import (
    "fmt"
    "math"
    "time"
    "torch"
)

func main() {

    // Generate some data
    data := [][]float64{
        {1, 2, 3, 4, 5},
        {6, 7, 8, 9, 10},
    }

    // Create a RNN model
    model := NewRNN(10, 20, 10)

    // Fit the model to the data
    for i := 0; i < 10; i++ {
        model.Train(data)
    }

    // Make predictions
    predictions := model.Predict(data)

    // Print the predictions
    fmt.Println(predictions)
}

type RNN struct {
    input_dim int
    hidden_dim int
    output_dim int

    weights []float64
    biases []float64

    h []float64
}

func NewRNN(input_dim, hidden_dim, output_dim int) *RNN {
    weights := make([]float64, input_dim*hidden_dim)
    biases := make([]float64, hidden_dim)

    for i := 0; i < input_dim*hidden_dim; i++ {
        weights[i] = math.Float64(rand.Intn(100)) - 50
    }

    for i := 0; i < hidden_dim; i++ {
        biases[i] = math.Float64(rand.Intn(100)) - 50
    }

    return &RNN{
        input_dim: input_dim,
        hidden_dim: hidden_dim,
        output_dim: output_dim,
        weights: weights,
        biases: biases,
        h: make([]float64, hidden_dim),
    }
}

func (r *RNN) Train(data [][]float64) {
    h := r.h
    for _, x := range data {
        z := torch.MatMul(x, r.weights) + r.biases
        h = torch.Tanh(z)
    }
    r.h = h
}

func (r *RNN) Predict(data [][]float64) []float64 {
    h := r.h
    predictions := make([]float64, len(data[0]))
    for i, x := range data {
        y := torch.MatMul(x, r.weights) + r.biases
        z := torch.Tanh(y)
        predictions[i] = z[0]
        h = z
    }
    return predictions
}
