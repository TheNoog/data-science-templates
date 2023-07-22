import org.apache.spark.ml.feature.PCA
import org.apache.spark.sql.SparkSession

object PCAExample {
  def main(args: Array[String]): Unit = {
    // Create a Spark session.
    val spark = SparkSession.builder.appName("PCAExample").getOrCreate()

    // Load the data.
    val data = Array(
      (1, 2, 3),
      (4, 5, 6),
      (7, 8, 9),
    )
    val df = spark.createDataFrame(data).toDF("x1", "x2", "x3")

    // Create a PCA model.
    val pca = new PCA()
    pca.setInputCol("features")
    pca.setOutputCol("pcaFeatures")
    pca.setK(2)

    // Fit the model to the data.
    val model = pca.fit(df)

    // Print the principal components.
    println(model.transform(df).select("pcaFeatures").show())

    // Tune the PCA parameters.
    import com.ray.tune.api.Trainable
    import com.ray.tune.api.ParameterSpace

    class PCATuneable extends Trainable[PCA] {
      def train(config: Trainable.TrainableParams): PCA = {
        val pca = new PCA()
        pca.setInputCol("features")
        pca.setOutputCol("pcaFeatures")
        pca.setK(config.get[Int]("k"))
        return pca
      }
    }

    val paramSpace = ParameterSpace.builder().add("k", 2.to(4).map(_.toInt)).build()
    val analysis = ray.tune.train(trainable = new PCATuneable(),
                                      parameters = paramSpace,
                                      searcher = "GridSearch",
                                      num_samples = 3)

    // Get the best PCA model.
    val bestPCA = analysis.best_trial().last_result().get[PCA]("model")

    // Print the best PCA model's parameters.
    println(bestPCA)
  }
}
