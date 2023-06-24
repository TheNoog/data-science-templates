package main

import (
	"fmt"
)

const (
	numStates       = 2
	numObservations = 3
)

func forwardAlgorithm(observations []int, initialProb []float64, transitionProb [][]float64, emissionProb [][]float64) {
	numObservations := len(observations)
	alpha := make([][]float64, numObservations)
	for i := range alpha {
		alpha[i] = make([]float64, numStates)
	}

	// Initialize alpha values for the first observation
	for state := 0; state < numStates; state++ {
		alpha[0][state] = initialProb[state] * emissionProb[state][observations[0]]
	}

	// Recursion: compute alpha values for subsequent observations
	for t := 1; t < numObservations; t++ {
		for state := 0; state < numStates; state++ {
			alpha[t][state] = 0.0
			for prevState := 0; prevState < numStates; prevState++ {
				alpha[t][state] += alpha[t-1][prevState] * transitionProb[prevState][state]
			}
			alpha[t][state] *= emissionProb[state][observations[t]]
		}
	}

	// Compute the probability of the observations
	prob := 0.0
	for state := 0; state < numStates; state++ {
		prob += alpha[numObservations-1][state]
	}

	// Print the probability of the observations
	fmt.Printf("Probability of the observations: %f\n", prob)
}

func main() {
	observations := []int{0, 1, 2}

	initialProb := []float64{0.8, 0.2}

	transitionProb := [][]float64{
		{0.7, 0.3},
		{0.4, 0.6},
	}

	emissionProb := [][]float64{
		{0.2, 0.3, 0.5},
		{0.6, 0.3, 0.1},
	}

	forwardAlgorithm(observations, initialProb, transitionProb, emissionProb)
}
