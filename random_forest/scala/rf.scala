import scala.util.Random

val NUM_TREES = 10
val NUM_FEATURES = 5

def loadData(filename: String): Seq[(Int, Seq[Double])] = {
  val data = scala.io.Source.fromFile(filename).getLines().map { line =>
    val features = line.split(",").map(_.toDouble)
    (features.head.toInt, features.tail)
  }.toSeq
  data
}

def createRandomForest(): Seq[Int] = {
  val treeLabels = Seq.fill(NUM_TREES)(Random.nextInt(2))
  treeLabels
}

def classifyData(data: Seq[(Int, Seq[Double])], treeLabels: Seq[Int]): Seq[Int] = {
  val predictions = data.map { dp =>
    val correctLabel = dp._1
    val prediction = 0
    treeLabels.foreach { treeLabel =>
      if (treeLabel == correctLabel) {
        prediction += 1
      }
    }
    prediction > NUM_TREES / 2
  }
  predictions
}

def calculateAccuracy(predictions: Seq[Int], data: Seq[(Int, Seq[Double])]): Double = {
  val correct = predictions.zip(data).count { case (p, d) => p == d._1 }
  correct.toDouble / data.length.toDouble * 100
}

def main(args: Array[String]): Unit = {
  val data = loadData("data.csv")
  val treeLabels = createRandomForest()
  val predictions = classifyData(data, treeLabels)
  val accuracy = calculateAccuracy(predictions, data)
  println(s"Accuracy: ${accuracy}%")
}
