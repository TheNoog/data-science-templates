using System;
using System.Collections.Generic;
using System.Linq;

namespace ConvolutionalNeuralNetwork
{
    class HiddenLayer
    {
        public double[,] weights;
        public double[] bias;

        public void InitializeWeights(int hiddenSize, int inputSize)
        {
            Random random = new Random();

            weights = new double[hiddenSize, inputSize];
            bias = new double[hiddenSize];

            for (int i = 0; i < hiddenSize; i++)
            {
                for (int j = 0; j < inputSize; j++)
                {
                    weights[i, j] = (random.NextDouble() - 0.5);
                }
                bias[i] = (random.NextDouble() - 0.5);
            }
        }
    }

    class OutputLayer
    {
        public double[,] weights;
        public double[] bias;

        public void InitializeWeights(int outputSize, int hiddenSize)
        {
            Random random = new Random();

            weights = new double[outputSize, hiddenSize];
            bias = new double[outputSize];

            for (int i = 0; i < outputSize; i++)
            {
                for (int j = 0; j < hiddenSize; j++)
                {
                    weights[i, j] = (random.NextDouble() - 0.5);
                }
                bias[i] = (random.NextDouble() - 0.5);
            }
        }
    }

    class Program
    {
        const int InputSize = 64;
        const int HiddenSize = 128;
        const int OutputSize = 10;
        const double LearningRate = 0.01;
        const int Epochs = 10;

        static double Sigmoid(double x)
        {
            return 1.0 / (1.0 + Math.Exp(-x));
        }

        static void ForwardPropagation(double[] input, HiddenLayer hiddenLayer, OutputLayer outputLayer, double[] output)
        {
            double[] hiddenOutput = new double[HiddenSize];

            for (int i = 0; i < HiddenSize; i++)
            {
                double sum = hiddenLayer.bias[i];

                for (int j = 0; j < InputSize; j++)
                {
                    sum += input[j] * hiddenLayer.weights[i, j];
                }

                hiddenOutput[i] = Sigmoid(sum);
            }

            for (int i = 0; i < OutputSize; i++)
            {
                double sum = outputLayer.bias[i];

                for (int j = 0; j < HiddenSize; j++)
                {
                    sum += hiddenOutput[j] * outputLayer.weights[i, j];
                }

                output[i] = Sigmoid(sum);
            }
        }

        static void BackPropagation(double[] input, double[] target, HiddenLayer hiddenLayer, OutputLayer outputLayer)
        {
            double[] hiddenOutput = new double[HiddenSize];
            double[] output = new double[OutputSize];

            ForwardPropagation(input, hiddenLayer, outputLayer, output);

            double[] outputDelta = new double[OutputSize];
            double[] hiddenDelta = new double[HiddenSize];

            for (int i = 0; i < OutputSize; i++)
            {
                outputDelta[i] = (output[i] - target[i]) * output[i] * (1 - output[i]);
            }

            for (int i = 0; i < HiddenSize; i++)
            {
                double error = 0.0;

                for (int j = 0; j < OutputSize; j++)
                {
                    error += outputLayer.weights[j, i] * outputDelta[j];
                }

                hiddenDelta[i] = error * hiddenOutput[i] * (1 - hiddenOutput[i]);
            }

            for (int i = 0; i < OutputSize; i++)
            {
                for (int j = 0; j < HiddenSize; j++)
                {
                    outputLayer.weights[i, j] -= LearningRate * outputDelta[i] * hiddenOutput[j];
                }

                outputLayer.bias[i] -= LearningRate * outputDelta[i];
            }

            for (int i = 0; i < HiddenSize; i++)
            {
                for (int j = 0; j < InputSize; j++)
                {
                    hiddenLayer.weights[i, j] -= LearningRate * hiddenDelta[i] * input[j];
                }

                hiddenLayer.bias[i] -= LearningRate * hiddenDelta[i];
            }
        }

        static void Main()
        {
            double[] input = { /* Input values here */ };
            double[] target = { /* Target values here */ };

            HiddenLayer hiddenLayer = new HiddenLayer();
            OutputLayer outputLayer = new OutputLayer();

            hiddenLayer.InitializeWeights(HiddenSize, InputSize);
            outputLayer.InitializeWeights(OutputSize, HiddenSize);

            for (int epoch = 0; epoch < Epochs; epoch++)
            {
                BackPropagation(input, target, hiddenLayer, outputLayer);
            }

            double[] output = new double[OutputSize];
            ForwardPropagation(input, hiddenLayer, outputLayer, output);

            Console.Write("Output: ");
            Console.WriteLine(string.Join(" ", output.Select(x => x.ToString())));
        }
    }
}
