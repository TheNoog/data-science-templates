function RNN(inputDim, hiddenDim, outputDim) {
    this.inputDim = inputDim;
    this.hiddenDim = hiddenDim;
    this.outputDim = outputDim;

    this.weights = [];
    for (let i = 0; i < inputDim; i++) {
        this.weights.push([]);
        for (let j = 0; j < hiddenDim; j++) {
            this.weights[i].push(Math.random() - 0.5);
        }
    }

    this.biases = [];
    for (let i = 0; i < hiddenDim; i++) {
        this.biases.push(Math.random() - 0.5);
    }

    this.h = [];
}

RNN.prototype.train = function(data) {
    for (let sequence of data) {
        this.h = [];
        for (let t of sequence) {
            let z = 0;
            for (let i = 0; i < inputDim; i++) {
                z += t * this.weights[i][this.h.length];
            }
            this.h.push(Math.tanh(z + this.biases[this.h.length]));
        }
    }
};

RNN.prototype.predict = function(data) {
    let predictions = [];
    this.h = [];
    for (let t of data) {
        let z = 0;
        for (let i = 0; i < inputDim; i++) {
            z += t * this.weights[i][this.h.length];
        }
        this.h.push(Math.tanh(z + this.biases[this.h.length]));
        predictions.push(this.h[this.h.length - 1]);
    }
    return predictions;
};
