using System;
using MathNet.Numerics.LinearAlgebra;

namespace NeuralNetwork
{
    class NeuralNetwork
    {
        private Matrix<double> weights1, weights2;
        private Vector<double> biases1, biases2;
        private double learningRate;

        public NeuralNetwork(int inputSize, int hiddenSize, int outputSize, double lr)
        {
            weights1 = Matrix<double>.Build.Random(inputSize, hiddenSize);
            weights2 = Matrix<double>.Build.Random(hiddenSize, outputSize);
            biases1 = Vector<double>.Build.Random(hiddenSize);
            biases2 = Vector<double>.Build.Random(outputSize);
            learningRate = lr;
        }

        private Matrix<double> Sigmoid(Matrix<double> x)
        {
            return 1.0 / (1.0 + (-x).Map(Math.Exp));
        }

        private Matrix<double> SigmoidDerivative(Matrix<double> x)
        {
            var sigmoidX = Sigmoid(x);
            return sigmoidX.PointwiseMultiply(1.0 - sigmoidX);
        }

        public void Train(Matrix<double> X, Matrix<double> y, int epochs)
        {
            for (int epoch = 0; epoch < epochs; ++epoch)
            {
                // Forward pass
                var hiddenLayer = Sigmoid(X.Multiply(weights1).Add(biases1.ToRowMatrix()));
                var outputLayer = Sigmoid(hiddenLayer.Multiply(weights2).Add(biases2.ToRowMatrix()));

                // Backpropagation
                var outputError = outputLayer.Subtract(y);
                var outputDelta = outputError.PointwiseMultiply(SigmoidDerivative(outputLayer));
                var hiddenError = outputDelta.Multiply(weights2.Transpose());
                var hiddenDelta = hiddenError.PointwiseMultiply(SigmoidDerivative(hiddenLayer));

                // Update weights and biases
                weights2 = weights2.Subtract(hiddenLayer.Transpose().Multiply(outputDelta).Multiply(learningRate));
                biases2 = biases2.Subtract(outputDelta.ColumnSums().Multiply(learningRate));
                weights1 = weights1.Subtract(X.Transpose().Multiply(hiddenDelta).Multiply(learningRate));
                biases1 = biases1.Subtract(hiddenDelta.ColumnSums().Multiply(learningRate));
            }
        }

        public Matrix<double> Predict(Matrix<double> X)
        {
            var hiddenLayer = Sigmoid(X.Multiply(weights1).Add(biases1.ToRowMatrix()));
            var outputLayer = Sigmoid(hiddenLayer.Multiply(weights2).Add(biases2.ToRowMatrix()));
            return outputLayer;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Example dataset
            var X = Matrix<double>.Build.DenseOfArray(new double[,]
            {
                { 0, 0 },
                { 0, 1 },
                { 1, 0 },
                { 1, 1 }
            });

            var y = Matrix<double>.Build.DenseOfArray(new double[,]
            {
                { 0 },
                { 1 },
                { 1 },
                { 0 }
            });

            // Create and train the neural network
            var nn = new NeuralNetwork(2, 4, 1, 0.1);
            nn.Train(X, y, 1000);

            // Make predictions on new data
            var predictions = nn.Predict(X);

            // Print the predictions
            for (int i = 0; i < predictions.RowCount; i++)
            {
                Console.WriteLine($"Input: [{X[i, 0]}, {X[i, 1]}], Predicted Output: {predictions[i, 0]}");
            }
        }
    }
}
