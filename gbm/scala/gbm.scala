import ml.dmlc.xgboost4j.scala.spark.XGBoostRegressor
import org.apache.spark.ml.evaluation.RegressionEvaluator
import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.ml.regression.{GBTRegressionModel, GBTRegressor}
import org.apache.spark.sql.{DataFrame, SparkSession}

// Create a Spark session
val spark = SparkSession.builder()
  .appName("GradientBoostedModelExample")
  .getOrCreate()

// Load the Boston Housing dataset
val boston = spark.read.format("libsvm").load("path/to/boston_housing.libsvm")

// Split the data into training and testing sets
val Array(trainingData, testData) = boston.randomSplit(Array(0.8, 0.2), seed = 42)

// Configure the feature vector assembler
val featureAssembler = new VectorAssembler()
  .setInputCols(boston.columns.dropRight(1))
  .setOutputCol("features")

// Transform the input data to include the feature vector
val assembledTrainingData = featureAssembler.transform(trainingData)
val assembledTestData = featureAssembler.transform(testData)

// Create the gradient boosted model
val model = new GBTRegressor()
  .setObjective("squarederror")  // Specify the loss function for regression
  .setFeatureSubsetStrategy("0.8")  // Fraction of features used for each tree
  .setMaxDepth(3)  // Maximum depth of each tree
  .setSubsamplingRate(0.8)  // Fraction of training samples used for each tree

// Train the model
val trainedModel = model.fit(assembledTrainingData)

// Make predictions on the test set
val predictions = trainedModel.transform(assembledTestData)

// Evaluate the model using the Mean Squared Error (MSE)
val evaluator = new RegressionEvaluator()
  .setLabelCol("label")
  .setPredictionCol("prediction")
  .setMetricName("mse")

val mse = evaluator.evaluate(predictions)
println(s"Mean Squared Error: $mse")

// Save the trained model
trainedModel.save("path/to/trained_model")
