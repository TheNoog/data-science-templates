import scala.util.Random

// Target probability distribution: a mixture of two Gaussian distributions
def targetDistribution(x: Double): Double = {
  val gaussian1 = 0.3 * math.exp(-0.2 * math.pow(x - 10, 2))
  val gaussian2 = 0.7 * math.exp(-0.2 * math.pow(x + 10, 2))
  gaussian1 + gaussian2
}

// Metropolis-Hastings algorithm for MCMC sampling
def metropolisHastings(target: Double => Double, numSamples: Int, initialState: Double, proposalStd: Double): List[Double] = {
  var currentState = initialState
  var accepted = 0
  var samples = List.empty[Double]

  val random = new Random()

  for (_ <- 1 to numSamples) {
    // Generate a proposal state from a normal distribution
    val proposal = currentState + proposalStd * random.nextGaussian()

    // Calculate the acceptance probability
    val acceptanceProb = math.min(1, target(proposal) / target(currentState))

    // Accept or reject the proposal
    if (random.nextDouble() < acceptanceProb) {
      currentState = proposal
      accepted += 1
    }

    // Save the current state as a sample
    samples = currentState :: samples
  }

  val acceptanceRate = accepted.toDouble / numSamples.toDouble
  println(s"Acceptance rate: ${acceptanceRate.roundTo(4)}")
  samples.reverse
}

// Define parameters for MCMC sampling
val numSamples = 10000
val initialState = 0.0
val proposalStd = 5.0

// Run MCMC sampling using Metropolis-Hastings algorithm
val samples = metropolisHastings(targetDistribution, numSamples, initialState, proposalStd)

// Print the sampled distribution
samples.foreach(println)
