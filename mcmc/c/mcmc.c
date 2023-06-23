#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

// Target probability distribution: a mixture of two Gaussian distributions
double target_distribution(double x) {
    double gaussian1 = 0.3 * exp(-0.2 * pow((x - 10), 2));
    double gaussian2 = 0.7 * exp(-0.2 * pow((x + 10), 2));
    return gaussian1 + gaussian2;
}

// Metropolis-Hastings algorithm for MCMC sampling
void metropolis_hastings(double (*target)(double), int num_samples, double initial_state, double proposal_std, double* samples) {
    double current_state = initial_state;
    int accepted = 0;

    for (int i = 0; i < num_samples; i++) {
        // Generate a proposal state from a normal distribution
        double proposal = current_state + (proposal_std * (rand() / (double)RAND_MAX));

        // Calculate the acceptance probability
        double acceptance_prob = fmin(1, (target(proposal) / target(current_state)));

        // Accept or reject the proposal
        if ((rand() / (double)RAND_MAX) < acceptance_prob) {
            current_state = proposal;
            accepted++;
        }

        // Save the current state as a sample
        samples[i] = current_state;
    }

    double acceptance_rate = (double)accepted / num_samples;
    printf("Acceptance rate: %.4f\n", acceptance_rate);
}

int main() {
    // Set random seed
    srand(time(NULL));

    // Define parameters for MCMC sampling
    int num_samples = 10000;
    double initial_state = 0;
    double proposal_std = 5;

    // Allocate memory for samples
    double* samples = (double*)malloc(num_samples * sizeof(double));

    // Run MCMC sampling using Metropolis-Hastings algorithm
    metropolis_hastings(target_distribution, num_samples, initial_state, proposal_std, samples);

    // Print the sampled distribution
    for (int i = 0; i < num_samples; i++) {
        printf("%.4f\n", samples[i]);
    }

    // Free memory
    free(samples);

    return 0;
}
