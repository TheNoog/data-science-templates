package main

import (
	"fmt"

	"gonum.org/v1/gonum/mat"
	"gonum.org/v1/gonum/stat/distmv"
	"gonum.org/v1/gonum/stat/gmm"
)

const (
	NSamples    = 500
	NComponents = 2
	NDimensions = 2
)

func main() {
	// Generate data from the first Gaussian distribution
	dist1 := distmv.NewNormal([]float64{0, 0}, mat.NewSymDense(NDimensions, nil).SetSym(0, 0, 1).SetSym(1, 1, 1), nil)
	data1 := make([][]float64, NSamples/2)
	for i := range data1 {
		data1[i] = dist1.Rand(nil)
	}

	// Generate data from the second Gaussian distribution
	dist2 := distmv.NewNormal([]float64{3, 3}, mat.NewSymDense(NDimensions, nil).SetSym(0, 0, 1).SetSym(1, 1, 1), nil)
	data2 := make([][]float64, NSamples/2)
	for i := range data2 {
		data2[i] = dist2.Rand(nil)
	}

	// Combine the data from both distributions
	data := make([][]float64, NSamples)
	copy(data[:NSamples/2], data1)
	copy(data[NSamples/2:], data2)

	// Fit the Gaussian Mixture Model
	weights := make([]float64, NComponents)
	means := make([][]float64, NComponents)
	covariances := make([]mat.Matrix, NComponents)
	model := gmm.NewModel(NDimensions, gmm.WithNComponents(NComponents), gmm.WithInitKMeans(data))
	model.Estimate(data, weights, means, covariances, nil)

	// Print the results
	fmt.Println("Weights:")
	for _, w := range weights {
		fmt.Printf("%.4f ", w)
	}
	fmt.Println()

	fmt.Println("\nMeans:")
	for _, mean := range means {
		fmt.Printf("%.4f %.4f\n", mean[0], mean[1])
	}
	fmt.Println()

	fmt.Println("Covariances:")
	for _, cov := range covariances {
		fmt.Printf("%.4f %.4f\n", cov.At(0, 0), cov.At(0, 1))
	}
}
