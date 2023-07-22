using System;
using System.Collections.Generic;

namespace RNN
{
    class RNN
    {
        public int InputDim;
        public int HiddenDim;
        public int OutputDim;

        public List<List<double>> Weights;
        public List<double> Biases;

        public List<double> h;

        public RNN(int input_dim, int hidden_dim, int output_dim)
        {
            this.InputDim = input_dim;
            this.HiddenDim = hidden_dim;
            this.OutputDim = output_dim;

            this.Weights = new List<List<double>>();
            for (int i = 0; i < input_dim; i++)
            {
                this.Weights.Add(new List<double>());
                for (int j = 0; j < hidden_dim; j++)
                {
                    this.Weights[i].Add((double)System.Random.NextDouble() - 0.5);
                }
            }

            this.Biases = new List<double>();
            for (int i = 0; i < hidden_dim; i++)
            {
                this.Biases.Add((double)System.Random.NextDouble() - 0.5);
            }

            this.h = new List<double>();
        }

        public void Train(List<List<double>> data)
        {
            for (int i = 0; i < data.Count; i++)
            {
                this.h = new List<double>();
                for (int j = 0; j < data[i].Count; j++)
                {
                    double z = 0;
                    for (int k = 0; k < data[i][j].Count; k++)
                    {
                        z += data[i][j][k] * this.Weights[k][j];
                    }
                    this.h = tanh(z + this.Biases[j]);
                }
            }
        }

        public List<double> Predict(List<List<double>> data)
        {
            List<double> predictions = new List<double>();
            for (int i = 0; i < data.Count; i++)
            {
                double z = 0;
                for (int j = 0; j < data[i].Count; j++)
                {
                    z += data[i][j] * this.Weights[j][i];
                }
                predictions.Add(tanh(z + this.Biases[i]));
            }
            return predictions;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Generate some data
            List<List<double>> data = new List<List<double>>();
            data.Add(new List<double> { 1, 2, 3, 4, 5 });
            data.Add(new List<double> { 6, 7, 8, 9, 10 });

            // Create a RNN model
            RNN model = new RNN(10, 20, 10);

            // Train the model to the data
            model.Train(data);

            // Make predictions
            List<double> predictions = model.Predict(data);

            // Print the predictions
            for (int i = 0; i < predictions.Count; i++)
            {
                Console.WriteLine(predictions[i]);
            }
        }
    }
}
