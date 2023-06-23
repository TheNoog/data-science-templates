import numpy as np
import matplotlib.pyplot as plt

# Target probability distribution: a mixture of two Gaussian distributions
def target_distribution(x):
    return 0.3 * np.exp(-0.2 * (x - 10)**2) + 0.7 * np.exp(-0.2 * (x + 10)**2)

# Metropolis-Hastings algorithm for MCMC sampling
def metropolis_hastings(target, num_samples, initial_state, proposal_std):
    samples = np.zeros(num_samples)
    current_state = initial_state
    accepted = 0

    for i in range(num_samples):
        # Generate a proposal state from a normal distribution
        proposal = np.random.normal(current_state, proposal_std)

        # Calculate the acceptance probability
        acceptance_prob = min(1, target(proposal) / target(current_state))

        # Accept or reject the proposal
        if np.random.rand() < acceptance_prob:
            current_state = proposal
            accepted += 1

        # Save the current state as a sample
        samples[i] = current_state

    acceptance_rate = accepted / num_samples
    print("Acceptance rate:", acceptance_rate)
    return samples

# Set random seed for reproducibility
np.random.seed(42)

# Define parameters for MCMC sampling
num_samples = 10000
initial_state = 0
proposal_std = 5

# Run MCMC sampling using Metropolis-Hastings algorithm
samples = metropolis_hastings(target_distribution, num_samples, initial_state, proposal_std)

# Plot the sampled distribution against the target distribution
x = np.linspace(-20, 20, 1000)
plt.plot(x, target_distribution(x), label="Target Distribution")
plt.hist(samples, bins=50, density=True, alpha=0.5, label="Sampled Distribution")
plt.xlabel("x")
plt.ylabel("Probability Density")
plt.legend()
plt.show()
