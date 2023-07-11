package main

import (
	"fmt"
	"math"
	"sort"
)

// DataPoint represents a data point with x, y coordinates and a label
type DataPoint struct {
	X     float64
	Y     float64
	Label int
}

// CalculateDistance calculates the Euclidean distance between two data points
func CalculateDistance(p1, p2 DataPoint) float64 {
	dx := p2.X - p1.X
	dy := p2.Y - p1.Y
	return math.Sqrt(dx*dx + dy*dy)
}

// Classify performs KNN classification
func Classify(trainingData []DataPoint, testPoint DataPoint, k int) int {
	// Calculate distances to all training data points
	distances := make([]float64, len(trainingData))
	for i, dataPoint := range trainingData {
		distances[i] = CalculateDistance(dataPoint, testPoint)
	}

	// Sort the distances in ascending order
	sortedDistances := make([]float64, len(distances))
	copy(sortedDistances, distances)
	sort.Float64s(sortedDistances)

	// Count the occurrences of each label among the k nearest neighbors
	labelCount := make(map[int]int)
	for i := 0; i < k; i++ {
		index := indexOf(distances, sortedDistances[i])
		labelCount[trainingData[index].Label]++
	}

	// Return the label with the highest count
	maxCount := 0
	predictedLabel := -1
	for label, count := range labelCount {
		if count > maxCount {
			maxCount = count
			predictedLabel = label
		}
	}

	return predictedLabel
}

// indexOf returns the index of a value in a slice
func indexOf(slice []float64, value float64) int {
	for i, v := range slice {
		if v == value {
			return i
		}
	}
	return -1
}

func main() {
	// Training data
	trainingData := []DataPoint{
		{X: 2.0, Y: 4.0, Label: 0},
		{X: 4.0, Y: 6.0, Label: 0},
		{X: 4.0, Y: 8.0, Label: 1},
		{X: 6.0, Y: 4.0, Label: 1},
		{X: 6.0, Y: 6.0, Label: 1},
	}

	// Test data point
	testPoint := DataPoint{X: 5.0, Y: 5.0, Label: 0}

	// Perform KNN classification
	k := 3
	predictedLabel := Classify(trainingData, testPoint, k)

	// Print the predicted label
	fmt.Println("Predicted label:", predictedLabel)
}