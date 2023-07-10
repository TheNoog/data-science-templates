# Define Point class
Point <- setClass("Point", slots = c(x = "numeric", y = "numeric"))

# Define Cluster class
Cluster <- setClass("Cluster", slots = c(centroid = "Point", numPoints = "integer"))

# Define distance function
distance <- function(p1, p2) {
  sqrt((p2@x - p1@x)^2 + (p2@y - p1@y)^2)
}

# Define function to initialize centroids
initializeCentroids <- function(dataPoints, k) {
  centroids <- vector(mode = "list", length = k)
  randomIndices <- sample(length(dataPoints), k)
  for (i in 1:k) {
    centroids[[i]] <- dataPoints[[randomIndices[i]]]
  }
  centroids
}

# Define function to assign points to centroids
assignPointsToCentroids <- function(dataPoints, clusters) {
  for (point in dataPoints) {
    minDistance <- distance(point, clusters[[1]]@centroid)
    clusterIndex <- 1
    for (j in 2:length(clusters)) {
      currDistance <- distance(point, clusters[[j]]@centroid)
      if (currDistance < minDistance) {
        minDistance <- currDistance
        clusterIndex <- j
      }
    }
    clusters[[clusterIndex]]@numPoints <- clusters[[clusterIndex]]@numPoints + 1
  }
}

# Define function to update centroids
updateCentroids <- function(dataPoints, clusters) {
  for (cluster in clusters) {
    sumX <- sumY <- 0
    numPoints <- cluster@numPoints
    for (point in dataPoints) {
      sumX <- sumX + point@x
      sumY <- sumY + point@y
    }
    cluster@centroid@x <- sumX / numPoints
    cluster@centroid@y <- sumY / numPoints
  }
}

# Define K-means function
kMeans <- function(dataPoints, k) {
  clusters <- lapply(initializeCentroids(dataPoints, k), function(centroid) Cluster(centroid, 0))
  maxIterations <- 100
  iteration <- 0
  while (iteration < maxIterations) {
    assignPointsToCentroids(dataPoints, clusters)
    updateCentroids(dataPoints, clusters)
    iteration <- iteration + 1
  }
  clusters
}

# Sample data points
dataPoints <- list(
  Point(2.0, 3.0),
  Point(2.5, 4.5),
  Point(1.5, 2.5),
  Point(6.0, 5.0),
  Point(7.0, 7.0),
  Point(5.0, 5.5),
  Point(9.0, 2.0),
  Point(10.0, 3.5),
  Point(9.5, 2.5)
)

k <- 3

clusters <- kMeans(dataPoints, k)

for (i in seq_along(clusters)) {
  cluster <- clusters[[i]]
  cat("Cluster", i, ": Centroid (", cluster@centroid@x, ",", cluster@centroid@y, "), Points:", cluster@numPoints, "\n")
}
