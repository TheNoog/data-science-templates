using System;
using System.Collections.Generic;
using System.Linq;

namespace LassoRegressionExample
{
    class Program
    {
        // Define the number of samples and features
        const int N_SAMPLES = 100;
        const int N_FEATURES = 20;

        // Function to calculate the mean squared error
        static double CalculateMeanSquaredError(List<double> yTrue, List<double> yPred)
        {
            double mse = 0.0;
            int n = yTrue.Count;
            for (int i = 0; i < n; i++)
            {
                double diff = yTrue[i] - yPred[i];
                mse += diff * diff;
            }
            return mse / n;
        }

        // Function to perform LASSO regression
        static void LassoRegression(List<List<double>> X, List<double> y, List<double> coefficients, double alpha)
        {
            // Maximum number of iterations for coordinate descent
            int maxIterations = 100;

            // Step size for coordinate descent
            double stepSize = 0.01;

            int nSamples = X.Count;
            int nFeatures = X[0].Count;

            // Initialize the coefficients to zero
            for (int i = 0; i < nFeatures; i++)
            {
                coefficients[i] = 0.0;
            }

            // Perform coordinate descent
            for (int iteration = 0; iteration < maxIterations; iteration++)
            {
                for (int j = 0; j < nFeatures; j++)
                {
                    // Calculate the gradient for feature j
                    double gradient = 0.0;
                    for (int i = 0; i < nSamples; i++)
                    {
                        double pred = 0.0;
                        for (int k = 0; k < nFeatures; k++)
                        {
                            if (k != j)
                            {
                                pred += X[i][k] * coefficients[k];
                            }
                        }
                        gradient += (y[i] - pred) * X[i][j];
                    }

                    // Update the coefficient using LASSO penalty
                    if (gradient > alpha)
                    {
                        coefficients[j] = (gradient - alpha) * stepSize;
                    }
                    else if (gradient < -alpha)
                    {
                        coefficients[j] = (gradient + alpha) * stepSize;
                    }
                    else
                    {
                        coefficients[j] = 0.0;
                    }
                }
            }
        }

        static void Main(string[] args)
        {
            // Generate some synthetic data
            Random rng = new Random(42);
            List<List<double>> X = new List<List<double>>();
            List<double> y = new List<double>();
            List<double> trueCoefficients = new List<double>(new double[N_FEATURES]);
            trueCoefficients[0] = 1.0;
            trueCoefficients[1] = 1.0;
            trueCoefficients[2] = 1.0;
            trueCoefficients[3] = 1.0;
            trueCoefficients[4] = 1.0;

            for (int i = 0; i < N_SAMPLES; i++)
            {
                List<double> sample = new List<double>();
                for (int j = 0; j < N_FEATURES; j++)
                {
                    sample.Add(rng.NextDouble());
                }
                X.Add(sample);

                double yValue = 0.0;
                for (int j = 0; j < N_FEATURES; j++)
                {
                    yValue += sample[j] * trueCoefficients[j];
                }
                yValue += 0.1 * rng.NextDouble();
                y.Add(yValue);
            }

            // Split the data into training and test sets
            int nTrainSamples = (int)(N_SAMPLES * 0.8);
            int nTestSamples = N_SAMPLES - nTrainSamples;
            List<List<double>> XTrain = X.Take(nTrainSamples).ToList();
            List<double> yTrain = y.Take(nTrainSamples).ToList();
            List<List<double>> XTest = X.Skip(nTrainSamples).ToList();
            List<double> yTest = y.Skip(nTrainSamples).ToList();

            // Perform LASSO regression
            double alpha = 0.1;
            List<double> coefficients = new List<double>(new double[N_FEATURES]);
            LassoRegression(XTrain, yTrain, coefficients, alpha);

            // Make predictions on the test set
            List<double> yPred = new List<double>();
            foreach (var sample in XTest)
            {
                double pred = 0.0;
                for (int j = 0; j < N_FEATURES; j++)
                {
                    pred += sample[j] * coefficients[j];
                }
                yPred.Add(pred);
            }

            // Calculate the mean squared error
            double mse = CalculateMeanSquaredError(yTest, yPred);
            Console.WriteLine("Mean Squared Error: " + mse);

            // Print the true coefficients and the estimated coefficients
            Console.Write("True Coefficients: ");
            foreach (var coeff in trueCoefficients)
            {
                Console.Write(coeff + " ");
            }
            Console.WriteLine();

            Console.Write("Estimated Coefficients: ");
            foreach (var coeff in coefficients)
            {
                Console.Write(coeff + " ");
            }
            Console.WriteLine();

            Console.ReadLine();
        }
    }
}
