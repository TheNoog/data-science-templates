defmodule MetropolisHastings do
  # Target probability distribution: a mixture of two Gaussian distributions
  def target_distribution(x) do
    gaussian1 = 0.3 * :math.exp(-0.2 * :math.pow(x - 10, 2))
    gaussian2 = 0.7 * :math.exp(-0.2 * :math.pow(x + 10, 2))
    gaussian1 + gaussian2
  end

  # Metropolis-Hastings algorithm for MCMC sampling
  def metropolis_hastings(target, num_samples, initial_state, proposal_std) do
    current_state = initial_state
    accepted = 0
    samples = []

    for _ <- 1..num_samples do
      # Generate a proposal state from a normal distribution
      proposal = current_state + proposal_std * :rand.normal()

      # Calculate the acceptance probability
      acceptance_prob = min(1, target.(proposal) / target.(current_state))

      # Accept or reject the proposal
      if :rand.uniform() < acceptance_prob do
        current_state = proposal
        accepted = accepted + 1
      end

      # Save the current state as a sample
      samples = [current_state | samples]
    end

    acceptance_rate = accepted / num_samples
    IO.puts("Acceptance rate: #{acceptance_rate}")
    Enum.reverse(samples)
  end
end

# Define parameters for MCMC sampling
num_samples = 10000
initial_state = 0.0
proposal_std = 5.0

# Run MCMC sampling using Metropolis-Hastings algorithm
samples = MetropolisHastings.metropolis_hastings(&MetropolisHastings.target_distribution/1, num_samples, initial_state, proposal_std)

# Print the sampled distribution
Enum.each(samples, &IO.puts(&1))
