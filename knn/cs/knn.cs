using System;
using System.Collections.Generic;
using System.Linq;

// Structure to represent a data point
struct DataPoint
{
    public double X;
    public double Y;
    public int Label;
}

class Program
{
    // Function to calculate Euclidean distance between two data points
    static double CalculateDistance(DataPoint p1, DataPoint p2)
    {
        double dx = p2.X - p1.X;
        double dy = p2.Y - p1.Y;
        return Math.Sqrt(dx * dx + dy * dy);
    }

    // Function to perform KNN classification
    static int Classify(List<DataPoint> trainingData, DataPoint testPoint, int k)
    {
        // Calculate distances to all training data points
        List<double> distances = new List<double>();
        foreach (var dataPoint in trainingData)
        {
            distances.Add(CalculateDistance(dataPoint, testPoint));
        }

        // Sort the distances in ascending order
        distances.Sort();

        // Count the occurrences of each label among the k nearest neighbors
        int[] labelCount = new int[2]; // Assuming 2 classes (0 and 1)
        for (int i = 0; i < k; i++)
        {
            int index = distances.FindIndex(d => d == distances[i]);
            labelCount[trainingData[index].Label]++;
        }

        // Return the label with the highest count
        return labelCount[0] > labelCount[1] ? 0 : 1;
    }

    static void Main(string[] args)
    {
        // Training data
        List<DataPoint> trainingData = new List<DataPoint>
        {
            new DataPoint { X = 2.0, Y = 4.0, Label = 0 },
            new DataPoint { X = 4.0, Y = 6.0, Label = 0 },
            new DataPoint { X = 4.0, Y = 8.0, Label = 1 },
            new DataPoint { X = 6.0, Y = 4.0, Label = 1 },
            new DataPoint { X = 6.0, Y = 6.0, Label = 1 }
        };

        // Test data point
        DataPoint testPoint = new DataPoint { X = 5.0, Y = 5.0, Label = 0 };

        // Perform KNN classification
        int k = 3;
        int predictedLabel = Classify(trainingData, testPoint, k);

        // Print the predicted label
        Console.WriteLine("Predicted label: " + predictedLabel);
    }
}