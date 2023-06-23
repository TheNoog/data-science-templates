# Target probability distribution: a mixture of two Gaussian distributions
def target_distribution(x)
    gaussian1 = 0.3 * Math.exp(-0.2 * (x - 10)**2)
    gaussian2 = 0.7 * Math.exp(-0.2 * (x + 10)**2)
    gaussian1 + gaussian2
  end
  
  # Metropolis-Hastings algorithm for MCMC sampling
  def metropolis_hastings(target, num_samples, initial_state, proposal_std)
    current_state = initial_state
    accepted = 0
    samples = []
  
    num_samples.times do
      # Generate a proposal state from a normal distribution
      proposal = current_state + proposal_std * rand * 2 - proposal_std
  
      # Calculate the acceptance probability
      acceptance_prob = [1, target.call(proposal) / target.call(current_state)].min
  
      # Accept or reject the proposal
      if rand < acceptance_prob
        current_state = proposal
        accepted += 1
      end
  
      # Save the current state as a sample
      samples << current_state
    end
  
    acceptance_rate = accepted.to_f / num_samples
    puts "Acceptance rate: #{acceptance_rate.round(4)}"
    samples
  end
  
  # Define parameters for MCMC sampling
  num_samples = 10000
  initial_state = 0.0
  proposal_std = 5.0
  
  # Run MCMC sampling using Metropolis-Hastings algorithm
  samples = metropolis_hastings(method(:target_distribution), num_samples, initial_state, proposal_std)
  
  # Print the sampled distribution
  samples.each { |sample| puts sample }
  