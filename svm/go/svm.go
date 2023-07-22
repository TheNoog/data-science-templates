package main

import (
    "fmt"
)

type SVM struct {
    C float64
    Kernel string
    W []float64
    B float64
}

func NewSVM(c float64, kernel string) *SVM {
    return &SVM{
        C: c,
        Kernel: kernel,
        W: make([]float64, 2),
        B: 0.0,
    }
}

func (svm *SVM) Fit(X [][]float64, y []int, n int) {
    for i := 0; i < n; i++ {
        score := 0.0
        for j := 0; j < 2; j++ {
            score += svm.W[j] * X[i][j]
        }
        if y[i] * score + svm.B <= 1.0 {
            for j := 0; j < 2; j++ {
                svm.W[j] += svm.C * y[i] * X[i][j]
            }
            svm.B += svm.C * y[i]
        }
    }
}

func (svm *SVM) Predict(X []float64) int {
    score := 0.0
    for j := 0; j < 2; j++ {
        score += svm.W[j] * X[j]
    }
    return score >= 0.0 ? 1 : -1
}

func main() {
    svm := NewSVM(1.0, "linear")
    svm.Fit([][]float64{
        {1, 2},
        {3, 4},
    }, []int{1, -1}, 2)
    fmt.Println(svm.Predict([]float64{5, 6}))
}
