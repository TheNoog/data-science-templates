import scala.collection.mutable
import scala.math.sqrt

// Case class to represent a data point
case class DataPoint(x: Double, y: Double, label: Int)

// Function to calculate Euclidean distance between two data points
def calculateDistance(p1: DataPoint, p2: DataPoint): Double = {
  val dx = p2.x - p1.x
  val dy = p2.y - p1.y
  sqrt(dx * dx + dy * dy)
}

// Function to perform KNN classification
def classify(trainingData: Seq[DataPoint], testPoint: DataPoint, k: Int): Int = {
  // Calculate distances to all training data points
  val distances = trainingData.map(dataPoint => calculateDistance(dataPoint, testPoint))

  // Sort the distances in ascending order
  val sortedDistances = distances.sorted

  // Count the occurrences of each label among the k nearest neighbors
  val labelCount = mutable.Map[Int, Int]().withDefaultValue(0)
  for (i <- 0 until k) {
    val index = distances.indexOf(sortedDistances(i))
    val label = trainingData(index).label
    labelCount(label) += 1
  }

  // Return the label with the highest count
  labelCount.maxBy(_._2)._1
}

// Training data
val trainingData = Seq(
  DataPoint(2.0, 4.0, 0),
  DataPoint(4.0, 6.0, 0),
  DataPoint(4.0, 8.0, 1),
  DataPoint(6.0, 4.0, 1),
  DataPoint(6.0, 6.0, 1)
)

// Test data point
val testPoint = DataPoint(5.0, 5.0, 0)

// Perform KNN classification
val k = 3
val predictedLabel = classify(trainingData, testPoint, k)

// Print the predicted label
println(s"Predicted label: $predictedLabel")
