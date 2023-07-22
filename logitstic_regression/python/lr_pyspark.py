import numpy as np
import pyspark
from pyspark.sql import SparkSession
from pyspark.ml.classification import LogisticRegression

# Initialize Spark Session
spark = SparkSession.builder.appName("LogisticRegression").getOrCreate()

# Load the data
data = spark.read.csv("data.csv", header=True, inferSchema=True)

# Split the data into features and labels
features = data.select("feature_1", "feature_2")
labels = data.select("label")

# Create a logistic regression model
model = LogisticRegression(maxIter=10)

# Fit the model to the data
model.fit(features, labels)

# Predict the labels for the test data
predictions = model.predict(features)

# Evaluate the model
evaluator = pyspark.ml.evaluation.BinaryClassificationEvaluator()
accuracy = evaluator.evaluate(predictions)

print("Accuracy:", accuracy)
