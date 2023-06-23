#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define INPUT_SIZE 64
#define HIDDEN_SIZE 128
#define OUTPUT_SIZE 10
#define LEARNING_RATE 0.01
#define EPOCHS 10

typedef struct {
    double weights[HIDDEN_SIZE][INPUT_SIZE];
    double bias[HIDDEN_SIZE];
} HiddenLayer;

typedef struct {
    double weights[OUTPUT_SIZE][HIDDEN_SIZE];
    double bias[OUTPUT_SIZE];
} OutputLayer;

void initializeWeights(double* weights, int size) {
    for (int i = 0; i < size; i++) {
        weights[i] = ((double) rand() / RAND_MAX) - 0.5;
    }
}

void initializeLayers(HiddenLayer* hiddenLayer, OutputLayer* outputLayer) {
    initializeWeights((double*)hiddenLayer->weights, HIDDEN_SIZE * INPUT_SIZE);
    initializeWeights(hiddenLayer->bias, HIDDEN_SIZE);
    initializeWeights((double*)outputLayer->weights, OUTPUT_SIZE * HIDDEN_SIZE);
    initializeWeights(outputLayer->bias, OUTPUT_SIZE);
}

double sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
}

void forwardPropagation(double* input, HiddenLayer hiddenLayer, OutputLayer outputLayer, double* output) {
    double hiddenOutput[HIDDEN_SIZE];

    for (int i = 0; i < HIDDEN_SIZE; i++) {
        double sum = hiddenLayer.bias[i];

        for (int j = 0; j < INPUT_SIZE; j++) {
            sum += input[j] * hiddenLayer.weights[i][j];
        }

        hiddenOutput[i] = sigmoid(sum);
    }

    for (int i = 0; i < OUTPUT_SIZE; i++) {
        double sum = outputLayer.bias[i];

        for (int j = 0; j < HIDDEN_SIZE; j++) {
            sum += hiddenOutput[j] * outputLayer.weights[i][j];
        }

        output[i] = sigmoid(sum);
    }
}

void backPropagation(double* input, double* target, HiddenLayer hiddenLayer, OutputLayer outputLayer) {
    double hiddenOutput[HIDDEN_SIZE];
    double output[OUTPUT_SIZE];

    forwardPropagation(input, hiddenLayer, outputLayer, output);

    double outputDelta[OUTPUT_SIZE];
    double hiddenDelta[HIDDEN_SIZE];

    for (int i = 0; i < OUTPUT_SIZE; i++) {
        outputDelta[i] = (output[i] - target[i]) * output[i] * (1 - output[i]);
    }

    for (int i = 0; i < HIDDEN_SIZE; i++) {
        double error = 0.0;

        for (int j = 0; j < OUTPUT_SIZE; j++) {
            error += outputLayer.weights[j][i] * outputDelta[j];
        }

        hiddenDelta[i] = error * hiddenOutput[i] * (1 - hiddenOutput[i]);
    }

    for (int i = 0; i < OUTPUT_SIZE; i++) {
        for (int j = 0; j < HIDDEN_SIZE; j++) {
            outputLayer.weights[i][j] -= LEARNING_RATE * outputDelta[i] * hiddenOutput[j];
        }

        outputLayer.bias[i] -= LEARNING_RATE * outputDelta[i];
    }

    for (int i = 0; i < HIDDEN_SIZE; i++) {
        for (int j = 0; j < INPUT_SIZE; j++) {
            hiddenLayer.weights[i][j] -= LEARNING_RATE * hiddenDelta[i] * input[j];
        }

        hiddenLayer.bias[i] -= LEARNING_RATE * hiddenDelta[i];
    }
}

int main() {
    double input[INPUT_SIZE] = { /* Input values here */ };
    double target[OUTPUT_SIZE] = { /* Target values here */ };

    HiddenLayer hiddenLayer;
    OutputLayer outputLayer;

    initializeLayers(&hiddenLayer, &outputLayer);

    for (int epoch = 0; epoch < EPOCHS; epoch++) {
        backPropagation(input, target, hiddenLayer, outputLayer);
    }

    double output[OUTPUT_SIZE];
    forwardPropagation(input, hiddenLayer, outputLayer, output);

    printf("Output: ");
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        printf("%lf ", output[i]);
    }
    printf("\n");

    return 0;
}
