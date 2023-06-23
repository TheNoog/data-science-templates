# Target probability distribution: a mixture of two Gaussian distributions
targetDistribution <- function(x) {
  gaussian1 <- 0.3 * exp(-0.2 * (x - 10)^2)
  gaussian2 <- 0.7 * exp(-0.2 * (x + 10)^2)
  return(gaussian1 + gaussian2)
}

# Metropolis-Hastings algorithm for MCMC sampling
metropolisHastings <- function(target, numSamples, initialState, proposalStd) {
  currentState <- initialState
  accepted <- 0
  samples <- numeric(numSamples)
  
  for (i in 1:numSamples) {
    # Generate a proposal state from a normal distribution
    proposal <- currentState + proposalStd * rnorm(1)
    
    # Calculate the acceptance probability
    acceptanceProb <- min(1, target(proposal) / target(currentState))
    
    # Accept or reject the proposal
    if (runif(1) < acceptanceProb) {
      currentState <- proposal
      accepted <- accepted + 1
    }
    
    # Save the current state as a sample
    samples[i] <- currentState
  }
  
  acceptanceRate <- accepted / numSamples
  cat("Acceptance rate:", round(acceptanceRate, 4), "\n")
  return(samples)
}

# Define parameters for MCMC sampling
numSamples <- 10000
initialState <- 0
proposalStd <- 5

# Run MCMC sampling using Metropolis-Hastings algorithm
samples <- metropolisHastings(targetDistribution, numSamples, initialState, proposalStd)

# Print the sampled distribution
for (sample in samples) {
  cat(sample, "\n")
}
