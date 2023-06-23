package main

import (
	"fmt"
	"math"
	"math/rand"
)

// Target probability distribution: a mixture of two Gaussian distributions
func targetDistribution(x float64) float64 {
	gaussian1 := 0.3 * math.Exp(-0.2*math.Pow((x-10), 2))
	gaussian2 := 0.7 * math.Exp(-0.2*math.Pow((x+10), 2))
	return gaussian1 + gaussian2
}

// Metropolis-Hastings algorithm for MCMC sampling
func metropolisHastings(target func(float64) float64, numSamples int, initialState float64, proposalStd float64) []float64 {
	currentState := initialState
	accepted := 0
	samples := make([]float64, numSamples)

	for i := 0; i < numSamples; i++ {
		// Generate a proposal state from a normal distribution
		proposal := currentState + proposalStd*rand.NormFloat64()

		// Calculate the acceptance probability
		acceptanceProb := math.Min(1, target(proposal)/target(currentState))

		// Accept or reject the proposal
		if rand.Float64() < acceptanceProb {
			currentState = proposal
			accepted++
		}

		// Save the current state as a sample
		samples[i] = currentState
	}

	acceptanceRate := float64(accepted) / float64(numSamples)
	fmt.Printf("Acceptance rate: %.4f\n", acceptanceRate)
	return samples
}

func main() {
	// Set random seed
	rand.Seed(42)

	// Define parameters for MCMC sampling
	numSamples := 10000
	initialState := 0.0
	proposalStd := 5.0

	// Run MCMC sampling using Metropolis-Hastings algorithm
	samples := metropolisHastings(targetDistribution, numSamples, initialState, proposalStd)

	// Print the sampled distribution
	for _, sample := range samples {
		fmt.Println(sample)
	}
}
