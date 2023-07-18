fun LDA(data: FloatArray, n: Int, d: Int, coef: FloatArray, means: FloatArray) {
    // Initialize the coef and means arrays.
    coef.fill(0.0f)
    means.fill(0.0f)

    // Calculate the means of the two classes.
    for (i in 0 until n) {
        if (data[i * d] == 0f) {
            means[0] += data[i * d]
        } else {
            means[1] += data[i * d]
        }
    }
    means[0] /= n / 2.0f
    means[1] /= n / 2.0f

    // Calculate the coef array.
    for (i in 0 until d) {
        for (j in 0 until n) {
            if (data[j * d] == 0f) {
                coef[i] += data[j * d] - means[0]
            } else {
                coef[i] += data[j * d] - means[1]
            }
        }
        coef[i] /= n / 2.0f
    }
}

fun main(args: Array<String>) {
    // Initialize the data array.
    val data = floatArrayOf(1.0f, 2.0f, 0.0f, 3.0f, 4.0f, 5.0f, 1.0f, 2.0f, 1.0f)
    val n = 3
    val d = 3

    // Initialize the coef and means arrays.
    val coef = FloatArray(d)
    val means = FloatArray(d)

    // Calculate the coef and means arrays.
    LDA(data, n, d, coef, means)

    // Print the coef array.
    for (i in 0 until d) {
        println(coef[i])
    }
}
