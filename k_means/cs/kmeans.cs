using System;
using System.Collections.Generic;
using System.Linq;

namespace KMeansClustering
{
    class Point
    {
        public double X { get; set; }
        public double Y { get; set; }
    }

    class Cluster
    {
        public Point Centroid { get; set; }
        public int NumPoints { get; set; }
    }

    class Program
    {
        private const int K = 3; // Number of clusters
        private const int MaxIterations = 100;

        static double Distance(Point p1, Point p2)
        {
            return Math.Sqrt(Math.Pow(p2.X - p1.X, 2) + Math.Pow(p2.Y - p1.Y, 2));
        }

        static void InitializeCentroids(List<Point> dataPoints, List<Cluster> clusters)
        {
            Random random = new Random();

            for (int i = 0; i < K; i++)
            {
                int randomIndex = random.Next(dataPoints.Count);
                clusters[i].Centroid = dataPoints[randomIndex];
                clusters[i].NumPoints = 0;
            }
        }

        static void AssignPointsToCentroids(List<Point> dataPoints, List<Cluster> clusters)
        {
            foreach (var dataPoint in dataPoints)
            {
                double minDistance = Distance(dataPoint, clusters[0].Centroid);
                int clusterIndex = 0;

                for (int j = 1; j < K; j++)
                {
                    double currDistance = Distance(dataPoint, clusters[j].Centroid);
                    if (currDistance < minDistance)
                    {
                        minDistance = currDistance;
                        clusterIndex = j;
                    }
                }

                clusters[clusterIndex].NumPoints++;
            }
        }

        static void UpdateCentroids(List<Point> dataPoints, List<Cluster> clusters)
        {
            foreach (var cluster in clusters)
            {
                double sumX = 0.0, sumY = 0.0;
                int numPoints = cluster.NumPoints;

                foreach (var dataPoint in dataPoints)
                {
                    sumX += dataPoint.X;
                    sumY += dataPoint.Y;
                }

                cluster.Centroid.X = sumX / numPoints;
                cluster.Centroid.Y = sumY / numPoints;
            }
        }

        static void KMeans(List<Point> dataPoints)
        {
            List<Cluster> clusters = new List<Cluster>(K);

            for (int i = 0; i < K; i++)
            {
                clusters.Add(new Cluster());
            }

            // Step 1: Initialize centroids randomly
            InitializeCentroids(dataPoints, clusters);

            int iteration = 0;
            while (iteration < MaxIterations)
            {
                // Step 2: Assign points to centroids
                AssignPointsToCentroids(dataPoints, clusters);

                // Step 3: Update centroids
                UpdateCentroids(dataPoints, clusters);

                iteration++;
            }

            // Print the final clusters
            for (int i = 0; i < K; i++)
            {
                Console.WriteLine($"Cluster {i + 1}: Centroid ({clusters[i].Centroid.X}, {clusters[i].Centroid.Y}), Points: {clusters[i].NumPoints}");
            }
        }

        static void Main()
        {
            // Sample data points
            List<Point> dataPoints = new List<Point>
            {
                new Point { X = 2.0, Y = 3.0 },
                new Point { X = 2.5, Y = 4.5 },
                new Point { X = 1.5, Y = 2.5 },
                new Point { X = 6.0, Y = 5.0 },
                new Point { X = 7.0, Y = 7.0 },
                new Point { X = 5.0, Y = 5.5 },
                new Point { X = 9.0, Y = 2.0 },
                new Point { X = 10.0, Y = 3.5 },
                new Point { X = 9.5, Y = 2.5 }
            };

            // Perform K-means clustering
            KMeans(dataPoints);
        }
    }
}