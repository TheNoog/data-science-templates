object HiddenMarkovModel {
  def forwardAlgorithm(observations: Array[Int], initialProb: Array[Double], transitionProb: Array[Array[Double]], emissionProb: Array[Array[Double]]): Unit = {
    val numObservations = observations.length
    val numStates = initialProb.length
    val alpha = Array.ofDim[Double](numObservations, numStates)

    // Initialize alpha values for the first observation
    for (state <- 0 until numStates) {
      alpha(0)(state) = initialProb(state) * emissionProb(state)(observations(0))
    }

    // Recursion: compute alpha values for subsequent observations
    for (t <- 1 until numObservations) {
      for (state <- 0 until numStates) {
        alpha(t)(state) = (0 until numStates)
          .map(prevState => alpha(t-1)(prevState) * transitionProb(prevState)(state))
          .sum * emissionProb(state)(observations(t))
      }
    }

    // Compute the probability of the observations
    val prob = alpha(numObservations - 1).sum

    // Print the probability of the observations
    println(s"Probability of the observations: $prob")
  }

  def main(args: Array[String]): Unit = {
    val NUM_STATES = 2
    val NUM_OBSERVATIONS = 3

    val observations = Array(0, 1, 2)

    val initialProb = Array(0.8, 0.2)

    val transitionProb = Array(
      Array(0.7, 0.3),
      Array(0.4, 0.6)
    )

    val emissionProb = Array(
      Array(0.2, 0.3, 0.5),
      Array(0.6, 0.3, 0.1)
    )

    forwardAlgorithm(observations, initialProb, transitionProb, emissionProb)
  }
}
