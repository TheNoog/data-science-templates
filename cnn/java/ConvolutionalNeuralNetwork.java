package cnn.java;

import java.util.Arrays;
import java.util.Random;

public class ConvolutionalNeuralNetwork {
    static class HiddenLayer {
        double[][] weights;
        double[] bias;

        HiddenLayer(int hiddenSize, int inputSize) {
            weights = new double[hiddenSize][inputSize];
            bias = new double[hiddenSize];

            Random random = new Random();
            for (int i = 0; i < hiddenSize; i++) {
                for (int j = 0; j < inputSize; j++) {
                    weights[i][j] = random.nextDouble() - 0.5;
                }
                bias[i] = random.nextDouble() - 0.5;
            }
        }
    }

    static class OutputLayer {
        double[][] weights;
        double[] bias;

        OutputLayer(int outputSize, int hiddenSize) {
            weights = new double[outputSize][hiddenSize];
            bias = new double[outputSize];

            Random random = new Random();
            for (int i = 0; i < outputSize; i++) {
                for (int j = 0; j < hiddenSize; j++) {
                    weights[i][j] = random.nextDouble() - 0.5;
                }
                bias[i] = random.nextDouble() - 0.5;
            }
        }
    }

    static final int InputSize = 64;
    static final int HiddenSize = 128;
    static final int OutputSize = 10;
    static final double LearningRate = 0.01;
    static final int Epochs = 10;

    static double sigmoid(double x) {
        return 1.0 / (1.0 + Math.exp(-x));
    }

    static double[] forwardPropagation(double[] input, HiddenLayer hiddenLayer, OutputLayer outputLayer) {
        double[] hiddenOutput = new double[HiddenSize];

        for (int i = 0; i < HiddenSize; i++) {
            double sum = hiddenLayer.bias[i];

            for (int j = 0; j < InputSize; j++) {
                sum += input[j] * hiddenLayer.weights[i][j];
            }

            hiddenOutput[i] = sigmoid(sum);
        }

        double[] output = new double[OutputSize];

        for (int i = 0; i < OutputSize; i++) {
            double sum = outputLayer.bias[i];

            for (int j = 0; j < HiddenSize; j++) {
                sum += hiddenOutput[j] * outputLayer.weights[i][j];
            }

            output[i] = sigmoid(sum);
        }

        return output;
    }

    static void backPropagation(double[] input, double[] target, HiddenLayer hiddenLayer, OutputLayer outputLayer) {
        double[] hiddenOutput = new double[HiddenSize];
        double[] output = forwardPropagation(input, hiddenLayer, outputLayer);

        double[] outputDelta = new double[OutputSize];
        double[] hiddenDelta = new double[HiddenSize];

        for (int i = 0; i < OutputSize; i++) {
            outputDelta[i] = (output[i] - target[i]) * output[i] * (1 - output[i]);
        }

        for (int i = 0; i < HiddenSize; i++) {
            double error = 0.0;

            for (int j = 0; j < OutputSize; j++) {
                error += outputLayer.weights[j][i] * outputDelta[j];
            }

            hiddenDelta[i] = error * hiddenOutput[i] * (1 - hiddenOutput[i]);
        }

        for (int i = 0; i < OutputSize; i++) {
            for (int j = 0; j < HiddenSize; j++) {
                outputLayer.weights[i][j] -= LearningRate * outputDelta[i] * hiddenOutput[j];
            }

            outputLayer.bias[i] -= LearningRate * outputDelta[i];
        }

        for (int i = 0; i < HiddenSize; i++) {
            for (int j = 0; j < InputSize; j++) {
                hiddenLayer.weights[i][j] -= LearningRate * hiddenDelta[i] * input[j];
            }

            hiddenLayer.bias[i] -= LearningRate * hiddenDelta[i];
        }
    }

    public static void main(String[] args) {
        double[] input = { /* Input values here */ };
        double[] target = { /* Target values here */ };

        HiddenLayer hiddenLayer = new HiddenLayer(HiddenSize, InputSize);
        OutputLayer outputLayer = new OutputLayer(OutputSize, HiddenSize);

        for (int epoch = 0; epoch < Epochs; epoch++) {
            backPropagation(input, target, hiddenLayer, outputLayer);
        }

        double[] output = forwardPropagation(input, hiddenLayer, outputLayer);

        System.out.println("Output: " + Arrays.toString(output));
    }
}
