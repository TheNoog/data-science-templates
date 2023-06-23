package main

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/sjwhitworth/golearn/base"
	"github.com/sjwhitworth/golearn/evaluation"
	"github.com/sjwhitworth/golearn/split"
	"github.com/sjwhitworth/golearn/trees"
)

func main() {
	rand.Seed(time.Now().UnixNano())

	// Load the dataset (Iris dataset as an example)
	iris, err := base.ParseCSVToInstances("iris.csv", true)
	if err != nil {
		panic(err)
	}

	// Split the dataset into training and testing sets
	trainData, testData := split.Dataset(iris, &split.KFold{Folds: 2, Shuffle: true}, 0)

	// Create a decision tree classifier
	tree := trees.NewID3DecisionTree(0.6)

	// Train the classifier on the training data
	err = tree.Fit(trainData)
	if err != nil {
		panic(err)
	}

	// Make predictions on the test data
	predictions, err := tree.Predict(testData)
	if err != nil {
		panic(err)
	}

	// Calculate the accuracy of the model
	confusionMat, err := evaluation.GetConfusionMatrix(testData, predictions)
	if err != nil {
		panic(err)
	}
	accuracy := evaluation.GetAccuracy(confusionMat)
	fmt.Printf("Accuracy: %.2f%%\n", accuracy*100)
}
