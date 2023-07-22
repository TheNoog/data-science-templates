import kotlin.math.max

class SVM(val C: Double, val kernel: String) {

    val w: Array<Double> = Array(2) { 0.0 }
    var b: Double = 0.0

    fun fit(X: Array<Array<Double>>, y: Array<Int>, n: Int) {
        for (i in 0 until n) {
            val score = w.dot(X[i]) + b
            if (y[i] * score <= 1.0) {
                for (j in 0 until 2) {
                    w[j] += C * y[i] * X[i][j]
                }
                b += C * y[i]
            }
        }
    }

    fun predict(X: Array<Double>): Int {
        val score = w.dot(X) + b
        return if (score >= 0.0) 1 else -1
    }
}

fun main(args: Array<String>) {
    val svm = SVM(1.0, "linear")
    svm.fit(arrayOf(arrayOf(1.0, 2.0), arrayOf(3.0, 4.0)), arrayOf(1, -1), 2)
    println(svm.predict(arrayOf(5.0, 6.0))) // prints "1"
}
