forwardAlgorithm <- function(observations, initialProb, transitionProb, emissionProb) {
  numObservations <- length(observations)
  alpha <- matrix(0, nrow = numObservations, ncol = NUM_STATES)

  # Initialize alpha values for the first observation
  for (state in 1:NUM_STATES) {
    alpha[1, state] <- initialProb[state] * emissionProb[state, observations[1]]
  }

  # Recursion: compute alpha values for subsequent observations
  for (t in 2:numObservations) {
    for (state in 1:NUM_STATES) {
      alpha[t, state] <- sum(alpha[t-1,] * transitionProb[, state]) * emissionProb[state, observations[t]]
    }
  }

  # Compute the probability of the observations
  prob <- sum(alpha[numObservations, ])

  # Print the probability of the observations
  cat("Probability of the observations:", prob, "\n")
}

NUM_STATES <- 2
NUM_OBSERVATIONS <- 3

observations <- c(0, 1, 2)

initialProb <- c(0.8, 0.2)

transitionProb <- matrix(c(0.7, 0.3, 0.4, 0.6), nrow = NUM_STATES, ncol = NUM_STATES, byrow = TRUE)

emissionProb <- matrix(c(0.2, 0.3, 0.5, 0.6, 0.3, 0.1), nrow = NUM_STATES, ncol = NUM_OBSERVATIONS, byrow = TRUE)

forwardAlgorithm(observations, initialProb, transitionProb, emissionProb)
