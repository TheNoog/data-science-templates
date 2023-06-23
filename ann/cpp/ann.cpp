#include <iostream>
#include <Eigen/Dense>
#include <Eigen/Core>
#include <Eigen/IterativeLinearSolvers>
#include <Eigen/SparseCore>

using namespace Eigen;

// Using the Eigen library for matrix operations and calculations. The NeuralNetwork class represents the ANN model.

class NeuralNetwork {
private:
    MatrixXd weights1, weights2;
    VectorXd biases1, biases2;
    double learningRate;

public:
    NeuralNetwork(int inputSize, int hiddenSize, int outputSize, double lr) {
        weights1 = MatrixXd::Random(inputSize, hiddenSize);
        weights2 = MatrixXd::Random(hiddenSize, outputSize);
        biases1 = VectorXd::Random(hiddenSize);
        biases2 = VectorXd::Random(outputSize);
        learningRate = lr;
    }

    MatrixXd sigmoid(const MatrixXd& x) const {
        return 1.0 / (1.0 + (-x).array().exp());
    }

    MatrixXd sigmoidDerivative(const MatrixXd& x) const {
        MatrixXd sigmoidX = sigmoid(x);
        return sigmoidX.array() * (1.0 - sigmoidX.array());
    }

    void train(const MatrixXd& X, const MatrixXd& y, int epochs) {
        for (int epoch = 0; epoch < epochs; ++epoch) {
            // Forward pass
            MatrixXd hiddenLayer = sigmoid(X * weights1 + biases1.replicate(X.rows(), 1));
            MatrixXd outputLayer = sigmoid(hiddenLayer * weights2 + biases2.replicate(hiddenLayer.rows(), 1));

            // Backpropagation
            MatrixXd outputError = outputLayer - y;
            MatrixXd outputDelta = outputError.array() * sigmoidDerivative(outputLayer).array();
            MatrixXd hiddenError = outputDelta * weights2.transpose();
            MatrixXd hiddenDelta = hiddenError.array() * sigmoidDerivative(hiddenLayer).array();

            // Update weights and biases
            weights2 -= learningRate * hiddenLayer.transpose() * outputDelta;
            biases2 -= learningRate * outputDelta.colwise().sum();
            weights1 -= learningRate * X.transpose() * hiddenDelta;
            biases1 -= learningRate * hiddenDelta.colwise().sum();
        }
    }

    MatrixXd predict(const MatrixXd& X) const {
        MatrixXd hiddenLayer = sigmoid(X * weights1 + biases1.replicate(X.rows(), 1));
        MatrixXd outputLayer = sigmoid(hiddenLayer * weights2 + biases2.replicate(hiddenLayer.rows(), 1));
        return outputLayer;
    }
};

int main() {
    // Example dataset
    MatrixXd X(4, 2);
    X << 0, 0,
         0, 1,
         1, 0,
         1, 1;

    MatrixXd y(4, 1);
    y << 0,
         1,
         1,
         0;

    // Create and train the neural network
    NeuralNetwork nn(2, 4, 1, 0.1);
    nn.train(X, y, 1000);

    // Make predictions on new data
    MatrixXd predictions = nn.predict(X);

    // Print the predictions
    for (int i = 0; i < predictions.rows(); ++i) {
        std::cout << "Input: [" << X(i, 0) << ", " << X(i, 1) << "], Predicted Output: " << predictions(i, 0) << std::endl;
    }

    return 0;
}
