#include <iostream>
#include <vector>
#include <cmath>

#define K 3 // Number of clusters
#define MAX_ITERATIONS 100

struct Point {
    double x;
    double y;
};

struct Cluster {
    Point centroid;
    int numPoints;
};

// Function to calculate Euclidean distance between two points
double distance(const Point& p1, const Point& p2) {
    return std::sqrt(std::pow(p2.x - p1.x, 2) + std::pow(p2.y - p1.y, 2));
}

// Function to initialize centroids randomly
void initializeCentroids(const std::vector<Point>& dataPoints, std::vector<Cluster>& clusters) {
    for (int i = 0; i < K; i++) {
        int randomIndex = rand() % dataPoints.size();
        clusters[i].centroid = dataPoints[randomIndex];
        clusters[i].numPoints = 0;
    }
}

// Function to assign each data point to the nearest centroid
void assignPointsToCentroids(const std::vector<Point>& dataPoints, std::vector<Cluster>& clusters) {
    for (const auto& dataPoint : dataPoints) {
        double minDistance = distance(dataPoint, clusters[0].centroid);
        int clusterIndex = 0;

        for (int j = 1; j < K; j++) {
            double currDistance = distance(dataPoint, clusters[j].centroid);
            if (currDistance < minDistance) {
                minDistance = currDistance;
                clusterIndex = j;
            }
        }

        clusters[clusterIndex].numPoints++;
    }
}

// Function to update the centroids based on the assigned points
void updateCentroids(const std::vector<Point>& dataPoints, std::vector<Cluster>& clusters) {
    for (auto& cluster : clusters) {
        double sumX = 0.0, sumY = 0.0;
        int numPoints = cluster.numPoints;

        for (const auto& dataPoint : dataPoints) {
            sumX += dataPoint.x;
            sumY += dataPoint.y;
        }

        cluster.centroid.x = sumX / numPoints;
        cluster.centroid.y = sumY / numPoints;
    }
}

// Function to perform K-means clustering
void kMeans(std::vector<Point>& dataPoints) {
    std::vector<Cluster> clusters(K);

    // Step 1: Initialize centroids randomly
    initializeCentroids(dataPoints, clusters);

    int iteration = 0;
    while (iteration < MAX_ITERATIONS) {
        // Step 2: Assign points to centroids
        assignPointsToCentroids(dataPoints, clusters);

        // Step 3: Update centroids
        updateCentroids(dataPoints, clusters);

        iteration++;
    }

    // Print the final clusters
    for (int i = 0; i < K; i++) {
        std::cout << "Cluster " << i + 1 << ": Centroid (" << clusters[i].centroid.x << ", "
            << clusters[i].centroid.y << "), Points: " << clusters[i].numPoints << std::endl;
    }
}

int main() {
    // Sample data points
    std::vector<Point> dataPoints = {
        {2.0, 3.0},
        {2.5, 4.5},
        {1.5, 2.5},
        {6.0, 5.0},
        {7.0, 7.0},
        {5.0, 5.5},
        {9.0, 2.0},
        {10.0, 3.5},
        {9.5, 2.5}
    };

    // Perform K-means clustering
    kMeans(dataPoints);

    return 0;
}