import org.apache.spark.ml.classification.DecisionTreeClassifier
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.sql.SparkSession

object DecisionTreeExample {
  def main(args: Array[String]): Unit = {
    // Create SparkSession
    val spark = SparkSession.builder
      .appName("DecisionTreeExample")
      .getOrCreate()

    // Load the dataset (Iris dataset as an example)
    val data = spark.read.format("csv")
      .option("header", "true")
      .option("inferSchema", "true")
      .load("iris.csv")

    // Prepare the data for training
    val assembler = new VectorAssembler()
      .setInputCols(Array("sepal_length", "sepal_width", "petal_length", "petal_width"))
      .setOutputCol("features")
    val dataset = assembler.transform(data)

    // Split the dataset into training and testing sets
    val Array(trainingData, testData) = dataset.randomSplit(Array(0.8, 0.2))

    // Create a decision tree classifier
    val dt = new DecisionTreeClassifier()
      .setLabelCol("species")
      .setFeaturesCol("features")

    // Train the classifier on the training data
    val model = dt.fit(trainingData)

    // Make predictions on the test data
    val predictions = model.transform(testData)

    // Evaluate the model
    val evaluator = new MulticlassClassificationEvaluator()
      .setLabelCol("species")
      .setPredictionCol("prediction")
      .setMetricName("accuracy")
    val accuracy = evaluator.evaluate(predictions)

    println(s"Accuracy: $accuracy")

    // Stop SparkSession
    spark.stop()
  }
}
