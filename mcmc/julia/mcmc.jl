# Target probability distribution: a mixture of two Gaussian distributions
function targetDistribution(x)
    gaussian1 = 0.3 * exp(-0.2 * (x - 10)^2)
    gaussian2 = 0.7 * exp(-0.2 * (x + 10)^2)
    return gaussian1 + gaussian2
end

# Metropolis-Hastings algorithm for MCMC sampling
function metropolisHastings(target, numSamples, initialState, proposalStd)
    currentState = initialState
    accepted = 0
    samples = Float64[]
    
    for i in 1:numSamples
        # Generate a proposal state from a normal distribution
        proposal = currentState + proposalStd * randn()
        
        # Calculate the acceptance probability
        acceptanceProb = min(1, target(proposal) / target(currentState))
        
        # Accept or reject the proposal
        if rand() < acceptanceProb
            currentState = proposal
            accepted += 1
        end
        
        # Save the current state as a sample
        push!(samples, currentState)
    end
    
    acceptanceRate = accepted / numSamples
    println("Acceptance rate: ", round(acceptanceRate, digits=4))
    return samples
end

# Define parameters for MCMC sampling
numSamples = 10000
initialState = 0.0
proposalStd = 5.0

# Run MCMC sampling using Metropolis-Hastings algorithm
samples = metropolisHastings(targetDistribution, numSamples, initialState, proposalStd)

# Print the sampled distribution
for sample in samples
    println(sample)
end
