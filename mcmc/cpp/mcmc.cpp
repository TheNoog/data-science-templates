#include <iostream>
#include <cmath>
#include <vector>
#include <random>

// Target probability distribution: a mixture of two Gaussian distributions
double target_distribution(double x) {
    double gaussian1 = 0.3 * exp(-0.2 * pow((x - 10), 2));
    double gaussian2 = 0.7 * exp(-0.2 * pow((x + 10), 2));
    return gaussian1 + gaussian2;
}

// Metropolis-Hastings algorithm for MCMC sampling
void metropolis_hastings(double (*target)(double), int num_samples, double initial_state, double proposal_std, std::vector<double>& samples) {
    double current_state = initial_state;
    int accepted = 0;

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    for (int i = 0; i < num_samples; i++) {
        // Generate a proposal state from a normal distribution
        std::normal_distribution<> proposal_dist(current_state, proposal_std);
        double proposal = proposal_dist(gen);

        // Calculate the acceptance probability
        double acceptance_prob = std::min(1.0, (target(proposal) / target(current_state)));

        // Accept or reject the proposal
        if (dis(gen) < acceptance_prob) {
            current_state = proposal;
            accepted++;
        }

        // Save the current state as a sample
        samples.push_back(current_state);
    }

    double acceptance_rate = static_cast<double>(accepted) / num_samples;
    std::cout << "Acceptance rate: " << acceptance_rate << std::endl;
}

int main() {
    // Define parameters for MCMC sampling
    int num_samples = 10000;
    double initial_state = 0;
    double proposal_std = 5;

    // Vector to store the samples
    std::vector<double> samples;

    // Run MCMC sampling using Metropolis-Hastings algorithm
    metropolis_hastings(target_distribution, num_samples, initial_state, proposal_std, samples);

    // Print the sampled distribution
    for (const auto& sample : samples) {
        std::cout << sample << std::endl;
    }

    return 0;
}
