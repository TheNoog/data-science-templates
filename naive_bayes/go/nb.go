package main

import (
	"fmt"
	"math"
)

type DataPoint struct {
	Features []float64
	Label    int
}

type Dataset struct {
	Data []DataPoint
}

func loadDataset() Dataset {
	// Load the dataset
	dataset := Dataset{}

	// Your code to load the data from a file or any other source goes here
	// Assign the features and labels to the Data slice in the dataset struct

	return dataset
}

func trainNaiveBayes(dataset Dataset) (priors []float64, likelihoods [][]float64) {
	numDataPoints := len(dataset.Data)
	numClasses := 3  // Number of classes in your dataset
	numFeatures := 4 // Number of features in your dataset

	classCounts := make([]int, numClasses)
	priors = make([]float64, numClasses)
	likelihoods = make([][]float64, numClasses)
	for i := range likelihoods {
		likelihoods[i] = make([]float64, numFeatures)
	}

	// Count the occurrences of each class label
	for _, dataPoint := range dataset.Data {
		classCounts[dataPoint.Label]++
	}

	// Calculate priors
	for i := 0; i < numClasses; i++ {
		priors[i] = float64(classCounts[i]) / float64(numDataPoints)
	}

	// Calculate likelihoods
	for i := 0; i < numClasses; i++ {
		for j := 0; j < numFeatures; j++ {
			featureSum := 0.0
			featureCount := 0

			// Sum the values of the feature for the current class
			for _, dataPoint := range dataset.Data {
				if dataPoint.Label == i {
					featureSum += dataPoint.Features[j]
					featureCount++
				}
			}

			// Calculate the average of the feature for the current class
			likelihoods[i][j] = featureSum / float64(featureCount)
		}
	}

	return priors, likelihoods
}

func predict(dataPoint DataPoint, priors []float64, likelihoods [][]float64) int {
	numClasses := len(priors)
	numFeatures := len(likelihoods[0])
	maxPosterior := 0.0
	predictedClass := -1

	// Calculate the posterior probability for each class
	for i := 0; i < numClasses; i++ {
		posterior := priors[i]

		for j := 0; j < numFeatures; j++ {
			posterior *= math.Exp(-(math.Pow(dataPoint.Features[j]-likelihoods[i][j], 2.0) / 2))
		}

		// Update the predicted class if the posterior is higher than the current maximum
		if posterior > maxPosterior {
			maxPosterior = posterior
			predictedClass = i
		}
	}

	return predictedClass
}

func main() {
	dataset := loadDataset()
	priors, likelihoods := trainNaiveBayes(dataset)

	// Example usage: Predict the class label for a new data point
	newDataPoint := DataPoint{
		Features: []float64{5.1, 3.5, 1.4, 0.2},
	}

	predictedLabel := predict(newDataPoint, priors, likelihoods)
	fmt.Println("Predicted Label:", predictedLabel)
}
