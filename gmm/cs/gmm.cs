using System;
using Accord.Statistics.Distributions;
using Accord.Statistics.Models.Mixture;

namespace GaussianMixtureModelExample
{
    class Program
    {
        static void Main(string[] args)
        {
            const int N_SAMPLES = 500;
            const int N_COMPONENTS = 2;

            // Generate data from the first Gaussian distribution
            var mean1 = new double[] { 0, 0 };
            var cov1 = new double[,] { { 1, 0 }, { 0, 1 } };
            var g1 = new MultivariateNormalDistribution(mean1, cov1);
            double[][] data1 = g1.Generate(N_SAMPLES / 2);

            // Generate data from the second Gaussian distribution
            var mean2 = new double[] { 3, 3 };
            var cov2 = new double[,] { { 1, 0 }, { 0, 1 } };
            var g2 = new MultivariateNormalDistribution(mean2, cov2);
            double[][] data2 = g2.Generate(N_SAMPLES / 2);

            // Combine the data from both distributions
            double[][] data = new double[N_SAMPLES][];
            Array.Copy(data1, data, data1.Length);
            Array.Copy(data2, 0, data, data1.Length, data2.Length);

            // Fit the Gaussian Mixture Model
            var gmm = new GaussianMixtureModel(N_COMPONENTS);
            double logLikelihood = gmm.Learn(data);

            // Retrieve the GMM parameters
            double[] weights = gmm.Weights;
            double[][] means = gmm.Means;
            double[][][] covs = gmm.Covariances;

            // Print the results
            Console.WriteLine("Weights:");
            foreach (double weight in weights)
            {
                Console.Write($"{weight} ");
            }
            Console.WriteLine();

            Console.WriteLine("\nMeans:");
            foreach (double[] mean in means)
            {
                Console.WriteLine($"{mean[0]} {mean[1]}");
            }
            Console.WriteLine();

            Console.WriteLine("Covariances:");
            foreach (double[][] cov in covs)
            {
                Console.WriteLine($"{cov[0][0]} {cov[0][1]}");
            }
        }
    }
}
