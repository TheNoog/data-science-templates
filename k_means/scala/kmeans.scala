import scala.util.Random
import math.sqrt

case class Point(x: Double, y: Double)

case class Cluster(centroid: Point, var numPoints: Int)

def distance(p1: Point, p2: Point): Double =
  sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2))

def initializeCentroids(dataPoints: List[Point], k: Int): List[Point] =
  Random.shuffle(dataPoints).take(k)

def assignPointsToCentroids(dataPoints: List[Point], clusters: List[Cluster]): Unit = {
  for (point <- dataPoints) {
    var minDistance = distance(point, clusters(0).centroid)
    var clusterIndex = 0

    for (j <- 1 until clusters.length) {
      val currDistance = distance(point, clusters(j).centroid)
      if (currDistance < minDistance) {
        minDistance = currDistance
        clusterIndex = j
      }
    }

    clusters(clusterIndex).numPoints += 1
  }
}

def updateCentroids(dataPoints: List[Point], clusters: List[Cluster]): Unit = {
  for (cluster <- clusters) {
    var sumX = 0.0
    var sumY = 0.0

    for (point <- dataPoints) {
      sumX += point.x
      sumY += point.y
    }

    val numPoints = cluster.numPoints
    cluster.centroid = Point(sumX / numPoints, sumY / numPoints)
  }
}

def kMeans(dataPoints: List[Point], k: Int): List[Cluster] = {
  var centroids = initializeCentroids(dataPoints, k)
  var clusters = centroids.map(centroid => Cluster(centroid, 0))
  
  val maxIterations = 100
  var iteration = 0
  
  while (iteration < maxIterations) {
    assignPointsToCentroids(dataPoints, clusters)
    updateCentroids(dataPoints, clusters)
    iteration += 1
  }

  clusters
}

val dataPoints = List(
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

val k = 3

val clusters = kMeans(dataPoints, k)

for (i <- clusters.indices) {
  val cluster = clusters(i)
  println(s"Cluster ${i + 1}: Centroid (${cluster.centroid.x}, ${cluster.centroid.y}), Points: ${cluster.numPoints}")
}