package main

import (
	"fmt"
	"math/rand"
	"time"

	"gonum.org/v1/gonum/floats"
	"gonum.org/v1/gonum/mat"
	"gonum.org/v1/gonum/stat"
)

func main() {
	// Generate some sample data
	rand.Seed(time.Now().UnixNano())
	data := make([]float64, 100)
	for i := range data {
		data[i] = float64(rand.Intn(100))
	}

	// Perform ARIMA modeling
	model := ARIMA(data, 1, 0, 1)
	// data is the input time series data for which we want to build an ARIMA model.
	// 1 is the value of p, which represents the order of autoregression. In this example, we are specifying an autoregressive order of 1, meaning the current value of the time series depends on its immediately preceding value.
	// 0 is the value of d, which represents the order of differencing. In this case, we are not applying any differencing to the data, so the time series is not modified.
	// 1 is the value of q, which represents the order of the moving average. Here, we are specifying a moving average order of 1, indicating that the current value of the time series depends on the residual error from the previous prediction.

	// Forecast next value
	nextValue := model.Forecast([]float64{data[len(data)-1]}, 1)

	fmt.Printf("Next value: %.2f\n", nextValue[0])
}

// ARIMA performs ARIMA modeling on the given time series data.
func ARIMA(data []float64, p, d, q int) *stat.ARIMA {
	// Convert data to a matrix
	matrix := mat.NewDense(len(data), 1, data)

	// Difference the data
	diffData := make([]float64, len(data)-d)
	for i := d; i < len(data); i++ {
		diffData[i-d] = data[i] - data[i-d]
	}

	// Fit an ARIMA model
	model := &stat.ARIMA{}
	model.Fit(diffData, p, d, q)

	// Obtain the residuals
	residuals := model.Residuals(diffData)

	// Add back the differenced data to get the original scale forecast
	scaleFactor := floats.Max(data) - floats.Min(data)
	forecast := make([]float64, 1)
	forecast[0] = model.Forecast([]float64{diffData[len(diffData)-1]}, 1)[0] + data[len(data)-1]

	// Create the ARIMA model with the residuals and forecast
	arimaModel := &stat.ARIMA{
		AR:            model.AR,
		MA:            model.MA,
		Diff:          d,
		Residuals:     residuals,
		ScaleFactor:   scaleFactor,
		Forecast:      forecast,
		NumParameters: model.NumParameters,
	}

	return arimaModel
}

// To run
// go mod init example
// go mod tidy
