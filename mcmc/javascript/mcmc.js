// Target probability distribution: a mixture of two Gaussian distributions
function targetDistribution(x) {
    const gaussian1 = 0.3 * Math.exp(-0.2 * Math.pow(x - 10, 2));
    const gaussian2 = 0.7 * Math.exp(-0.2 * Math.pow(x + 10, 2));
    return gaussian1 + gaussian2;
  }
  
  // Metropolis-Hastings algorithm for MCMC sampling
  function metropolisHastings(target, numSamples, initialState, proposalStd) {
    let currentState = initialState;
    let accepted = 0;
    const samples = [];
  
    for (let i = 0; i < numSamples; i++) {
      // Generate a proposal state from a normal distribution
      const proposal = currentState + proposalStd * (Math.random() * 2 - 1);
  
      // Calculate the acceptance probability
      const acceptanceProb = Math.min(1, target(proposal) / target(currentState));
  
      // Accept or reject the proposal
      if (Math.random() < acceptanceProb) {
        currentState = proposal;
        accepted++;
      }
  
      // Save the current state as a sample
      samples.push(currentState);
    }
  
    const acceptanceRate = accepted / numSamples;
    console.log(`Acceptance rate: ${acceptanceRate.toFixed(4)}`);
    return samples;
  }
  
  // Define parameters for MCMC sampling
  const numSamples = 10000;
  const initialState = 0.0;
  const proposalStd = 5.0;
  
  // Run MCMC sampling using Metropolis-Hastings algorithm
  const samples = metropolisHastings(targetDistribution, numSamples, initialState, proposalStd);
  
  // Print the sampled distribution
  samples.forEach(sample => console.log(sample));
  