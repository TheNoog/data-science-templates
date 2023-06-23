using System;
using System.Collections.Generic;
using System.Linq;

namespace NaiveBayesClassifier
{
    class DataPoint
    {
        public List<double> Features { get; set; }
        public int Label { get; set; }
    }

    class Dataset
    {
        public List<DataPoint> Data { get; set; }
    }

    class Program
    {
        static Dataset LoadDataset()
        {
            // Load the dataset
            Dataset dataset = new Dataset();

            // Your code to load the data from a file or any other source goes here
            // Assign the features and labels to the Data list in the dataset object

            return dataset;
        }

        static void TrainNaiveBayes(Dataset dataset, double[] priors, double[][] likelihoods)
        {
            int numDataPoints = dataset.Data.Count;
            int numClasses = priors.Length;
            int numFeatures = likelihoods[0].Length;
            int[] classCounts = new int[numClasses];

            // Count the occurrences of each class label
            foreach (var dataPoint in dataset.Data)
            {
                classCounts[dataPoint.Label]++;
            }

            // Calculate priors
            for (int i = 0; i < numClasses; i++)
            {
                priors[i] = (double)classCounts[i] / numDataPoints;
            }

            // Calculate likelihoods
            for (int i = 0; i < numClasses; i++)
            {
                for (int j = 0; j < numFeatures; j++)
                {
                    double featureSum = 0.0;
                    int featureCount = 0;

                    // Sum the values of the feature for the current class
                    foreach (var dataPoint in dataset.Data)
                    {
                        if (dataPoint.Label == i)
                        {
                            featureSum += dataPoint.Features[j];
                            featureCount++;
                        }
                    }

                    // Calculate the average of the feature for the current class
                    likelihoods[i][j] = featureSum / featureCount;
                }
            }
        }

        static int Predict(DataPoint dataPoint, double[] priors, double[][] likelihoods)
        {
            int numClasses = priors.Length;
            int numFeatures = likelihoods[0].Length;
            double maxPosterior = 0.0;
            int predictedClass = -1;

            // Calculate the posterior probability for each class
            for (int i = 0; i < numClasses; i++)
            {
                double posterior = priors[i];

                for (int j = 0; j < numFeatures; j++)
                {
                    posterior *= Math.Exp(-(Math.Pow(dataPoint.Features[j] - likelihoods[i][j], 2.0) / 2));
                }

                // Update the predicted class if the posterior is higher than the current maximum
                if (posterior > maxPosterior)
                {
                    maxPosterior = posterior;
                    predictedClass = i;
                }
            }

            return predictedClass;
        }

        static void Main(string[] args)
        {
            Dataset dataset = LoadDataset();
            int numClasses = 3; // Number of classes in your dataset
            int numFeatures = 4; // Number of features in your dataset

            double[] priors = new double[numClasses];
            double[][] likelihoods = new double[numClasses][];

            for (int i = 0; i < numClasses; i++)
            {
                likelihoods[i] = new double[numFeatures];
            }

            TrainNaiveBayes(dataset, priors, likelihoods);

            // Example usage: Predict the class label for a new data point
            DataPoint newDataPoint = new DataPoint
            {
                Features = new List<double> { 5.1, 3.5, 1.4, 0.2 }
            };

            int predictedLabel = Predict(newDataPoint, priors, likelihoods);
            Console.WriteLine("Predicted Label: " + predictedLabel);

            Console.ReadLine();
        }
    }
}
