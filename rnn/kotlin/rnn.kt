class RNN(val inputDim: Int, val hiddenDim: Int, val outputDim: Int) {

    val weights = Array(inputDim) { Array(hiddenDim) { Math.random() - 0.5 } }
    val biases = Array(hiddenDim) { Math.random() - 0.5 }

    val h = Array(hiddenDim) { 0.0 }

    fun train(data: List<List<Double>>) {
        for (sequence in data) {
            for (t in sequence) {
                val z = 0.0
                for (i in 0 until inputDim) {
                    z += t * weights[i][h.size]
                }
                h = h.plus(Math.tanh(z + biases[h.size]))
            }
        }
    }

    fun predict(data: List<Double>): List<Double> {
        val predictions = mutableListOf<Double>()
        h = Array(hiddenDim) { 0.0 }
        for (t in data) {
            val z = 0.0
            for (i in 0 until inputDim) {
                z += t * weights[i][h.size]
            }
            h = h.plus(Math.tanh(z + biases[h.size]))
            predictions.add(h.last())
        }
        return predictions
    }

}
