package main

import (
	"fmt"
	"math"
	"math/rand"
)

type Point struct {
	X, Y float64
}

type Cluster struct {
	Centroid   Point
	NumPoints  int
}

func distance(p1, p2 Point) float64 {
	return math.Sqrt(math.Pow(p2.X-p1.X, 2) + math.Pow(p2.Y-p1.Y, 2))
}

func initializeCentroids(dataPoints []Point, k int) []Cluster {
	clusters := make([]Cluster, k)

	for i := 0; i < k; i++ {
		randomIndex := rand.Intn(len(dataPoints))
		clusters[i].Centroid = dataPoints[randomIndex]
		clusters[i].NumPoints = 0
	}

	return clusters
}

func assignPointsToCentroids(dataPoints []Point, clusters []Cluster) {
	for i := range dataPoints {
		minDistance := distance(dataPoints[i], clusters[0].Centroid)
		clusterIndex := 0

		for j := 1; j < len(clusters); j++ {
			currDistance := distance(dataPoints[i], clusters[j].Centroid)
			if currDistance < minDistance {
				minDistance = currDistance
				clusterIndex = j
			}
		}

		clusters[clusterIndex].NumPoints++
	}
}

func updateCentroids(dataPoints []Point, clusters []Cluster) {
	for i := range clusters {
		sumX, sumY := 0.0, 0.0
		numPoints := clusters[i].NumPoints

		for j := range dataPoints {
			sumX += dataPoints[j].X
			sumY += dataPoints[j].Y
		}

		clusters[i].Centroid.X = sumX / float64(numPoints)
		clusters[i].Centroid.Y = sumY / float64(numPoints)
	}
}

func kMeans(dataPoints []Point, k int) []Cluster {
	clusters := initializeCentroids(dataPoints, k)
	maxIterations := 100
	iteration := 0

	for iteration < maxIterations {
		assignPointsToCentroids(dataPoints, clusters)
		updateCentroids(dataPoints, clusters)
		iteration++
	}

	return clusters
}

func main() {
	dataPoints := []Point{
		{2.0, 3.0},
		{2.5, 4.5},
		{1.5, 2.5},
		{6.0, 5.0},
		{7.0, 7.0},
		{5.0, 5.5},
		{9.0, 2.0},
		{10.0, 3.5},
		{9.5, 2.5},
	}

	k := 3

	clusters := kMeans(dataPoints, k)

	for i, cluster := range clusters {
		fmt.Printf("Cluster %d: Centroid (%.2f, %.2f), Points: %d\n", i+1, cluster.Centroid.X, cluster.Centroid.Y, cluster.NumPoints)
	}
}