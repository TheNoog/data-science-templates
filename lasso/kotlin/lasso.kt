import kotlin.random.Random

// Define the number of samples and features
const val N_SAMPLES = 100
const val N_FEATURES = 20

// Function to calculate the mean squared error
fun calculateMeanSquaredError(yTrue: DoubleArray, yPred: DoubleArray): Double {
    val n = yTrue.size
    var mse = 0.0
    for (i in 0 until n) {
        val diff = yTrue[i] - yPred[i]
        mse += diff * diff
    }
    return mse / n
}

// Function to perform LASSO regression
fun lassoRegression(X: Array<DoubleArray>, y: DoubleArray, coefficients: DoubleArray, alpha: Double) {
    // Maximum number of iterations for coordinate descent
    val maxIterations = 100

    // Step size for coordinate descent
    val stepSize = 0.01

    val nSamples = X.size
    val nFeatures = X[0].size

    // Initialize the coefficients to zero
    coefficients.fill(0.0)

    // Perform coordinate descent
    for (iteration in 0 until maxIterations) {
        for (j in 0 until nFeatures) {
            // Calculate the gradient for feature j
            var gradient = 0.0
            for (i in 0 until nSamples) {
                var pred = 0.0
                for (k in 0 until nFeatures) {
                    if (k != j) {
                        pred += X[i][k] * coefficients[k]
                    }
                }
                gradient += (y[i] - pred) * X[i][j]
            }

            // Update the coefficient using LASSO penalty
            when {
                gradient > alpha -> coefficients[j] = (gradient - alpha) * stepSize
                gradient < -alpha -> coefficients[j] = (gradient + alpha) * stepSize
                else -> coefficients[j] = 0.0
            }
        }
    }
}

// Generate some synthetic data
fun generateSyntheticData(): Pair<Array<DoubleArray>, DoubleArray> {
    val X = Array(N_SAMPLES) { DoubleArray(N_FEATURES) }
    val y = DoubleArray(N_SAMPLES)

    val rng = Random(42)

    for (i in 0 until N_SAMPLES) {
        for (j in 0 until N_FEATURES) {
            X[i][j] = rng.nextDouble()
        }

        y[i] = 0.0
        for (j in 0 until N_FEATURES) {
            y[i] += X[i][j] * (j + 1)
        }
        y[i] += 0.1 * rng.nextDouble()
    }

    return Pair(X, y)
}

// Main function
fun main() {
    // Generate some synthetic data
    val (X, y) = generateSyntheticData()

    // Split the data into training and test sets
    val nTrainSamples = (N_SAMPLES * 0.8).toInt()
    val nTestSamples = N_SAMPLES - nTrainSamples
    val XTrain = X.copyOfRange(0, nTrainSamples)
    val yTrain = y.copyOfRange(0, nTrainSamples)
    val XTest = X.copyOfRange(nTrainSamples, N_SAMPLES)
    val yTest = y.copyOfRange(nTrainSamples, N_SAMPLES)

    // Perform LASSO regression
    val alpha = 0.1
    val coefficients = DoubleArray(N_FEATURES)
    lassoRegression(XTrain, yTrain, coefficients, alpha)

    // Make predictions on the test set
    val yPred = DoubleArray(nTestSamples) { i ->
        XTest[i].foldIndexed(0.0) { j, acc, x -> acc + x * coefficients[j] }
    }

    // Calculate the mean squared error
    val mse = calculateMeanSquaredError(yTest, yPred)
    println("Mean Squared Error: $mse")

    // Print the true coefficients and the estimated coefficients
    print("True Coefficients: [1.0 ")
    for (i in 1 until N_FEATURES) {
        print("${i + 1} ")
    }
    println("]")

    println("Estimated Coefficients: ${coefficients.joinToString(" ")}")
}

fun main(args: Array<String>) {
    main()
}
