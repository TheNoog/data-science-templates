using System;
using System.Collections.Generic;

namespace MCMC
{
    // Target probability distribution: a mixture of two Gaussian distributions
    class TargetDistribution
    {
        public static double Evaluate(double x)
        {
            double gaussian1 = 0.3 * Math.Exp(-0.2 * Math.Pow((x - 10), 2));
            double gaussian2 = 0.7 * Math.Exp(-0.2 * Math.Pow((x + 10), 2));
            return gaussian1 + gaussian2;
        }
    }

    // Metropolis-Hastings algorithm for MCMC sampling
    class MetropolisHastings
    {
        private Random random;

        public MetropolisHastings()
        {
            random = new Random();
        }

        public List<double> Run(double initial, double proposalStd, int numSamples)
        {
            List<double> samples = new List<double>();
            double currentState = initial;
            int accepted = 0;

            for (int i = 0; i < numSamples; i++)
            {
                // Generate a proposal state from a normal distribution
                double proposal = currentState + (proposalStd * random.NextDouble());

                // Calculate the acceptance probability
                double acceptanceProb = Math.Min(1, TargetDistribution.Evaluate(proposal) / TargetDistribution.Evaluate(currentState));

                // Accept or reject the proposal
                if (random.NextDouble() < acceptanceProb)
                {
                    currentState = proposal;
                    accepted++;
                }

                // Save the current state as a sample
                samples.Add(currentState);
            }

            double acceptanceRate = (double)accepted / numSamples;
            Console.WriteLine("Acceptance rate: " + acceptanceRate);
            return samples;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Define parameters for MCMC sampling
            int numSamples = 10000;
            double initial = 0;
            double proposalStd = 5;

            // Create an instance of the Metropolis-Hastings algorithm
            MetropolisHastings mcmc = new MetropolisHastings();

            // Run MCMC sampling using Metropolis-Hastings algorithm
            List<double> samples = mcmc.Run(initial, proposalStd, numSamples);

            // Print the sampled distribution
            foreach (var sample in samples)
            {
                Console.WriteLine(sample);
            }
        }
    }
}
