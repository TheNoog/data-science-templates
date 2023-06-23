package mcmc.java;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MetropolisHastings {
    // Target probability distribution: a mixture of two Gaussian distributions
    public static double targetDistribution(double x) {
        double gaussian1 = 0.3 * Math.exp(-0.2 * Math.pow((x - 10), 2));
        double gaussian2 = 0.7 * Math.exp(-0.2 * Math.pow((x + 10), 2));
        return gaussian1 + gaussian2;
    }

    // Metropolis-Hastings algorithm for MCMC sampling
    public static List<Double> metropolisHastings(DoubleUnaryOperator target, int numSamples, double initialState, double proposalStd) {
        double currentState = initialState;
        int accepted = 0;
        List<Double> samples = new ArrayList<>();

        Random random = new Random();
        for (int i = 0; i < numSamples; i++) {
            // Generate a proposal state from a normal distribution
            double proposal = currentState + proposalStd * random.nextGaussian();

            // Calculate the acceptance probability
            double acceptanceProb = Math.min(1, target.applyAsDouble(proposal) / target.applyAsDouble(currentState));

            // Accept or reject the proposal
            if (random.nextDouble() < acceptanceProb) {
                currentState = proposal;
                accepted++;
            }

            // Save the current state as a sample
            samples.add(currentState);
        }

        double acceptanceRate = (double) accepted / numSamples;
        System.out.printf("Acceptance rate: %.4f\n", acceptanceRate);
        return samples;
    }

    public static void main(String[] args) {
        // Define parameters for MCMC sampling
        int numSamples = 10000;
        double initialState = 0.0;
        double proposalStd = 5.0;

        // Run MCMC sampling using Metropolis-Hastings algorithm
        List<Double> samples = metropolisHastings(MetropolisHastings::targetDistribution, numSamples, initialState, proposalStd);

        // Print the sampled distribution
        for (double sample : samples) {
            System.out.println(sample);
        }
    }
}
