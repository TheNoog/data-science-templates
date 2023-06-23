using System;

namespace LinearRegressionExample
{
    class Program
    {
        // Function to calculate the mean
        static double CalculateMean(double[] arr)
        {
            double sum = 0.0;
            foreach (double num in arr)
            {
                sum += num;
            }
            return sum / arr.Length;
        }

        // Function to calculate the slope (beta1)
        static double CalculateSlope(double[] x, double[] y)
        {
            double mean_x = CalculateMean(x);
            double mean_y = CalculateMean(y);
            double numerator = 0.0;
            double denominator = 0.0;

            for (int i = 0; i < x.Length; i++)
            {
                numerator += (x[i] - mean_x) * (y[i] - mean_y);
                denominator += (x[i] - mean_x) * (x[i] - mean_x);
            }

            return numerator / denominator;
        }

        // Function to calculate the intercept (beta0)
        static double CalculateIntercept(double[] x, double[] y, double slope)
        {
            double mean_x = CalculateMean(x);
            double mean_y = CalculateMean(y);

            return mean_y - slope * mean_x;
        }

        // Function to make predictions
        static double Predict(double x, double slope, double intercept)
        {
            return slope * x + intercept;
        }

        static void Main(string[] args)
        {
            double[] x = { 1, 2, 3, 4, 5 };  // Input features
            double[] y = { 2, 4, 5, 4, 6 };  // Target variable

            double slope = CalculateSlope(x, y);
            double intercept = CalculateIntercept(x, y, slope);

            double[] new_x = { 6, 7 };

            Console.WriteLine("Input\tPredicted Output");
            for (int i = 0; i < new_x.Length; i++)
            {
                double y_pred = Predict(new_x[i], slope, intercept);
                Console.WriteLine($"{new_x[i]}\t{y_pred}");
            }
        }
    }
}
