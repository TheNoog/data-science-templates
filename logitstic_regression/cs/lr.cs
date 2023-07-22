namespace LogisticRegression
{
    public class LogisticRegression
    {
        private double[] _weights;
        private double _bias;

        public LogisticRegression(int featureCount)
        {
            _weights = new double[featureCount];
            _bias = 0.0;
        }

        public void Train(double[] features, int label)
        {
            double prediction = Sigmoid(Dot(features, _weights) + _bias);
            double error = label - prediction;

            for (int i = 0; i < featureCount; i++)
            {
                _weights[i] += error * features[i];
            }
            _bias += error;
        }

        public int Predict(double[] features)
        {
            double prediction = Sigmoid(Dot(features, _weights) + _bias);
            if (prediction > 0.5)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        private double Sigmoid(double x)
        {
            return 1.0 / (1.0 + Math.Exp(-x));
        }

        private double Dot(double[] x, double[] y)
        {
            double sum = 0.0;
            for (int i = 0; i < x.Length; i++)
            {
                sum += x[i] * y[i];
            }
            return sum;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Initialize the data
            double[] features = { 1.0, 2.0 };
            int label = 1;

            // Create the logistic regression model
            LogisticRegression model = new LogisticRegression(2);

            // Train the model
            for (int i = 0; i < 100; i++)
            {
                model.Train(features, label);
            }

            // Predict the label for a new data point
            double[] newFeatures = { 3.0, 4.0 };
            int newLabel = model.Predict(newFeatures);

            // Print the prediction
            Console.WriteLine("The predicted label is {0}", newLabel);
        }
    }
}
