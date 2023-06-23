import org.apache.spark.ml.clustering.{GaussianMixture, GaussianMixtureModel}
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.sql.SparkSession

object GMMExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("GMMExample")
      .master("local[*]")
      .getOrCreate()

    val NSamples = 500
    val NComponents = 2

    // Generate data from the first Gaussian distribution
    val data1 = Array.fill(NSamples / 2)(Vectors.dense(util.Random.nextGaussian(), util.Random.nextGaussian()))

    // Generate data from the second Gaussian distribution
    val data2 = Array.fill(NSamples / 2)(Vectors.dense(util.Random.nextGaussian() + 3, util.Random.nextGaussian() + 3))

    // Combine the data from both distributions
    val data = spark.createDataFrame(data1 ++ data2).toDF("features")

    // Fit the Gaussian Mixture Model
    val gmm = new GaussianMixture()
      .setK(NComponents)
      .fit(data)

    // Retrieve the GMM parameters
    val weights = gmm.weights
    val means = gmm.gaussians.map(_.mean)
    val covariances = gmm.gaussians.map(_.cov)

    // Print the results
    println("Weights:")
    weights.foreach(w => print(w + " "))

    println("\n\nMeans:")
    means.foreach(m => println(m.toArray.mkString(" ")))

    println("\nCovariances:")
    covariances.foreach(c => println(c.toArray.mkString(" ")))

    spark.stop()
  }
}
