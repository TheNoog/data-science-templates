package main

import (
	"fmt"

	"github.com/sjwhitworth/golearn/base"
	"github.com/sjwhitworth/golearn/evaluation"
	"github.com/sjwhitworth/golearn/xgboost"
)

func main() {
	// Load the dataset
	trainData, err := base.ParseCSVToInstances("train.csv", true)
	if err != nil {
		panic(err)
	}
	testData, err := base.ParseCSVToInstances("test.csv", true)
	if err != nil {
		panic(err)
	}

	// Set up the XGBoost model
	xgbModel := xgboost.NewXGBoost(xgboost.Regression)

	// Train the model
	xgbModel.Fit(trainData)

	// Make predictions on the test data
	predictions, err := xgbModel.Predict(testData)
	if err != nil {
		panic(err)
	}

	// Evaluate the model using root mean squared error (RMSE)
	rmse := evaluation.GetRootMeanSquaredError(testData, predictions)
	fmt.Println("RMSE:", rmse)
}
