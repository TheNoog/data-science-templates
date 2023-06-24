using System;

namespace HiddenMarkovModelExample
{
    class Program
    {
        static void ForwardAlgorithm(int[] observations, double[] initialProb, double[,] transitionProb, double[,] emissionProb)
        {
            int numObservations = observations.Length;
            double[,] alpha = new double[numObservations, NUM_STATES];

            // Initialize alpha values for the first observation
            for (int state = 0; state < NUM_STATES; state++)
            {
                alpha[0, state] = initialProb[state] * emissionProb[state, observations[0]];
            }

            // Recursion: compute alpha values for subsequent observations
            for (int t = 1; t < numObservations; t++)
            {
                for (int state = 0; state < NUM_STATES; state++)
                {
                    alpha[t, state] = 0.0;
                    for (int prevState = 0; prevState < NUM_STATES; prevState++)
                    {
                        alpha[t, state] += alpha[t - 1, prevState] * transitionProb[prevState, state];
                    }
                    alpha[t, state] *= emissionProb[state, observations[t]];
                }
            }

            // Compute the probability of the observations
            double prob = 0.0;
            for (int state = 0; state < NUM_STATES; state++)
            {
                prob += alpha[numObservations - 1, state];
            }

            // Print the probability of the observations
            Console.WriteLine("Probability of the observations: " + prob);
        }

        const int NUM_STATES = 2;
        const int NUM_OBSERVATIONS = 3;

        static void Main(string[] args)
        {
            int[] observations = { 0, 1, 2 };

            double[] initialProb = { 0.8, 0.2 };

            double[,] transitionProb = {
                { 0.7, 0.3 },
                { 0.4, 0.6 }
            };

            double[,] emissionProb = {
                { 0.2, 0.3, 0.5 },
                { 0.6, 0.3, 0.1 }
            };

            ForwardAlgorithm(observations, initialProb, transitionProb, emissionProb);

            Console.ReadLine();
        }
    }
}
