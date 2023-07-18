package main

import (
    "fmt"
)

func LDA(data []float64, n, d int, coef, means []float64) {
    // Initialize the coef and means arrays.
    for i := 0; i < d; i++ {
        coef[i] = 0.0
        means[i] = 0.0
    }

    // Calculate the means of the two classes.
    for i := 0; i < n; i++ {
        if data[i * d] == 0 {
            means[0] += data[i * d]
        } else {
            means[1] += data[i * d]
        }
    }
    means[0] /= n / 2.0
    means[1] /= n / 2.0

    // Calculate the coef array.
    for i := 0; i < d; i++ {
        for j := 0; j < n; j++ {
            if data[j * d] == 0 {
                coef[i] += data[j * d] - means[0]
            } else {
                coef[i] += data[j * d] - means[1]
            }
        }
        coef[i] /= n / 2.0
    }
}

func main() {
    // Initialize the data array.
    data := []float64{1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0}
    n := 3
    d := 3

    // Initialize the coef and means arrays.
    coef := make([]float64, d)
    means := make([]float64, d)

    // Calculate the coef and means arrays.
    LDA(data, n, d, coef, means)

    // Print the coef array.
    for i := 0; i < d; i++ {
        fmt.Println(coef[i])
    }

    // Print the means array.
    for i := 0; i < d; i++ {
        fmt.Println(means[i])
    }
}
