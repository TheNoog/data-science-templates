#include <iostream>
#include <cmath>
#include <random>
#include <vector>

#define INPUT_SIZE 64
#define HIDDEN_SIZE 128
#define OUTPUT_SIZE 10
#define LEARNING_RATE 0.01
#define EPOCHS 10

class HiddenLayer {
public:
    double weights[HIDDEN_SIZE][INPUT_SIZE];
    double bias[HIDDEN_SIZE];

    void initializeWeights() {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_real_distribution<double> dis(-0.5, 0.5);

        for (int i = 0; i < HIDDEN_SIZE; i++) {
            for (int j = 0; j < INPUT_SIZE; j++) {
                weights[i][j] = dis(gen);
            }
            bias[i] = dis(gen);
        }
    }
};

class OutputLayer {
public:
    double weights[OUTPUT_SIZE][HIDDEN_SIZE];
    double bias[OUTPUT_SIZE];

    void initializeWeights() {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_real_distribution<double> dis(-0.5, 0.5);

        for (int i = 0; i < OUTPUT_SIZE; i++) {
            for (int j = 0; j < HIDDEN_SIZE; j++) {
                weights[i][j] = dis(gen);
            }
            bias[i] = dis(gen);
        }
    }
};

double sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
}

void forwardPropagation(const std::vector<double>& input, const HiddenLayer& hiddenLayer, const OutputLayer& outputLayer, std::vector<double>& output) {
    std::vector<double> hiddenOutput(HIDDEN_SIZE);

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

void backPropagation(const std::vector<double>& input, const std::vector<double>& target, HiddenLayer& hiddenLayer, OutputLayer& outputLayer) {
    std::vector<double> hiddenOutput(HIDDEN_SIZE);
    std::vector<double> output(OUTPUT_SIZE);

    forwardPropagation(input, hiddenLayer, outputLayer, output);

    std::vector<double> outputDelta(OUTPUT_SIZE);
    std::vector<double> hiddenDelta(HIDDEN_SIZE);

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
    std::vector<double> input = { /* Input values here */ };
    std::vector<double> target = { /* Target values here */ };

    HiddenLayer hiddenLayer;
    OutputLayer outputLayer;

    hiddenLayer.initializeWeights();
    outputLayer.initializeWeights();

    for (int epoch = 0; epoch < EPOCHS; epoch++) {
        backPropagation(input, target, hiddenLayer, outputLayer);
    }

    std::vector<double> output(OUTPUT_SIZE);
    forwardPropagation(input, hiddenLayer, outputLayer, output);

    std::cout << "Output: ";
    for (double value : output) {
        std::cout << value << " ";
    }
    std::cout << std::endl;

    return 0;
}
