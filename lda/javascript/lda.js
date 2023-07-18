function LDA(data, n, d, coef, means) {
    // Initialize the coef and means arrays.
    coef = [];
    means = [];
    for (let i = 0; i < d; i++) {
        coef.push(0);
        means.push(0);
    }

    // Calculate the means of the two classes.
    for (let i = 0; i < n; i++) {
        if (data[i * d] == 0) {
            means[0] += data[i * d];
        } else {
            means[1] += data[i * d];
        }
    }
    means[0] /= n / 2.0;
    means[1] /= n / 2.0;

    // Calculate the coef array.
    for (let i = 0; i < d; i++) {
        for (let j = 0; j < n; j++) {
            if (data[j * d] == 0) {
                coef[i] += data[j * d] - means[0];
            } else {
                coef[i] += data[j * d] - means[1];
            }
        }
        coef[i] /= n / 2.0;
    }

    return coef;
}

const data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0];
const n = 3;
const d = 3;

const coef = LDA(data, n, d, [], []);

console.log(coef);
