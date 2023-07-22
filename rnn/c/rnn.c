#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct RNN {
    int input_dim;
    int hidden_dim;
    int output_dim;

    double *weights;
    double *biases;

    double *h;
} RNN;

RNN *NewRNN(int input_dim, int hidden_dim, int output_dim) {
    double *weights = malloc(sizeof(double) * input_dim * hidden_dim);
    double *biases = malloc(sizeof(double) * hidden_dim);

    for (int i = 0; i < input_dim * hidden_dim; i++) {
        weights[i] = ((double)rand() / (double)RAND_MAX) - 0.5;
    }

    for (int i = 0; i < hidden_dim; i++) {
        biases[i] = ((double)rand() / (double)RAND_MAX) - 0.5;
    }

    RNN *r = malloc(sizeof(RNN));
    r->input_dim = input_dim;
    r->hidden_dim = hidden_dim;
    r->output_dim = output_dim;
    r->weights = weights;
    r->biases = biases;
    r->h = malloc(sizeof(double) * hidden_dim);

    return r;
}

void TrainRNN(RNN *r, [][]double data) {
    for (int i = 0; i < len(data); i++) {
        r->h = 0;
        for (int j = 0; j < len(data[i]); j++) {
            double z = 0;
            for (int k = 0; k < len(data[i][j]); k++) {
                z += data[i][j][k] * r->weights[k * r->hidden_dim + j];
            }
            r->h = tanh(z + r->biases[j]);
        }
    }
}

[]double PredictRNN(RNN *r, [][]double data) {
    []double predictions = malloc(sizeof(double) * len(data[0]));
    for (int i = 0; i < len(data); i++) {
        double z = 0;
        for (int j = 0; j < len(data[i]); j++) {
            z += data[i][j] * r->weights[j * r->hidden_dim + i];
        }
        predictions[i] = tanh(z + r->biases[i]);
    }
    return predictions;
}

int main() {
    // Generate some data
    [][]double data = [][]double{
        {1, 2, 3, 4, 5},
        {6, 7, 8, 9, 10},
    };

    // Create a RNN model
    RNN *model = NewRNN(10, 20, 10);

    // Train the model to the data
    TrainRNN(model, data);

    // Make predictions
    []double predictions = PredictRNN(model, data);

    // Print the predictions
    for (int i = 0; i < len(predictions); i++) {
        printf("%f\n", predictions[i]);
    }

    return 0;
}
