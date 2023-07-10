#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define K 3 // Number of clusters
#define MAX_ITERATIONS 100

typedef struct {
    double x;
    double y;
} Point;

typedef struct {
    Point centroid;
    int numPoints;
} Cluster;

// Function to calculate Euclidean distance between two points
double distance(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

// Function to initialize centroids randomly
void initializeCentroids(Point* dataPoints, Cluster* clusters, int numDataPoints) {
    for (int i = 0; i < K; i++) {
        int randomIndex = rand() % numDataPoints;
        clusters[i].centroid = dataPoints[randomIndex];
        clusters[i].numPoints = 0;
    }
}

// Function to assign each data point to the nearest centroid
void assignPointsToCentroids(Point* dataPoints, Cluster* clusters, int numDataPoints) {
    for (int i = 0; i < numDataPoints; i++) {
        double minDistance = distance(dataPoints[i], clusters[0].centroid);
        int clusterIndex = 0;

        for (int j = 1; j < K; j++) {
            double currDistance = distance(dataPoints[i], clusters[j].centroid);
            if (currDistance < minDistance) {
                minDistance = currDistance;
                clusterIndex = j;
            }
        }

        clusters[clusterIndex].numPoints++;
    }
}

// Function to update the centroids based on the assigned points
void updateCentroids(Point* dataPoints, Cluster* clusters) {
    for (int i = 0; i < K; i++) {
        double sumX = 0.0, sumY = 0.0;
        int numPoints = clusters[i].numPoints;

        for (int j = 0; j < numPoints; j++) {
            sumX += dataPoints[j].x;
            sumY += dataPoints[j].y;
        }

        clusters[i].centroid.x = sumX / numPoints;
        clusters[i].centroid.y = sumY / numPoints;
    }
}

// Function to perform K-means clustering
void kMeans(Point* dataPoints, int numDataPoints) {
    Cluster clusters[K];

    // Step 1: Initialize centroids randomly
    initializeCentroids(dataPoints, clusters, numDataPoints);

    int iteration = 0;
    while (iteration < MAX_ITERATIONS) {
        // Step 2: Assign points to centroids
        assignPointsToCentroids(dataPoints, clusters, numDataPoints);

        // Step 3: Update centroids
        updateCentroids(dataPoints, clusters);

        iteration++;
    }

    // Print the final clusters
    for (int i = 0; i < K; i++) {
        printf("Cluster %d: Centroid (%.2f, %.2f), Points: %d\n",
            i + 1, clusters[i].centroid.x, clusters[i].centroid.y, clusters[i].numPoints);
    }
}

int main() {
    // Sample data points
    Point dataPoints[] = {
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

    int numDataPoints = sizeof(dataPoints) / sizeof(dataPoints[0]);

    // Perform K-means clustering
    kMeans(dataPoints, numDataPoints);

    return 0;
}