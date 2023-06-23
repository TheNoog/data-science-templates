package main

import "fmt"

// Function to calculate the mean
func calculateMean(arr []float64) float64 {
	sum := 0.0
	for _, num := range arr {
		sum += num
	}
	return sum / float64(len(arr))
}

// Function to calculate the slope (beta1)
func calculateSlope(x, y []float64) float64 {
	meanX := calculateMean(x)
	meanY := calculateMean(y)
	numerator := 0.0
	denominator := 0.0

	for i := 0; i < len(x); i++ {
		numerator += (x[i] - meanX) * (y[i] - meanY)
		denominator += (x[i] - meanX) * (x[i] - meanX)
	}

	return numerator / denominator
}

// Function to calculate the intercept (beta0)
func calculateIntercept(x, y []float64, slope float64) float64 {
	meanX := calculateMean(x)
	meanY := calculateMean(y)

	return meanY - slope*meanX
}

// Function to make predictions
func predict(x, slope, intercept float64) float64 {
	return slope*x + intercept
}

func main() {
	x := []float64{1, 2, 3, 4, 5} // Input features
	y := []float64{2, 4, 5, 4, 6} // Target variable

	slope := calculateSlope(x, y)
	intercept := calculateIntercept(x, y, slope)

	newX := []float64{6, 7}

	fmt.Println("Input\tPredicted Output")
	for _, val := range newX {
		yPred := predict(val, slope, intercept)
		fmt.Printf("%g\t%g\n", val, yPred)
	}
}
