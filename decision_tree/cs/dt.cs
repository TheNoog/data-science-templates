using System;
using System.Linq;
using Sklearn;
using Sklearn.ModelSelection;
using Sklearn.Tree;
using Sklearn.Metrics;

class Program
{
    static void Main(string[] args)
    {
        // Load the dataset (Iris dataset as an example)
        var iris = Datasets.LoadIris();
        var X = iris.Data;
        var y = iris.Target;

        // Split the dataset into training and testing sets
        var random = new Random(42);
        var splitter = new TrainTestSplit(randomState: random);
        var (X_train, X_test, y_train, y_test) = splitter.Split(X, y, test_size: 0.2);

        // Create a decision tree classifier
        var classifier = new DecisionTreeClassifier();

        // Train the classifier on the training data
        classifier.Fit(X_train, y_train);

        // Make predictions on the test data
        var y_pred = classifier.Predict(X_test);

        // Calculate the accuracy of the model
        var accuracy = Metrics.AccuracyScore(y_test, y_pred);
        Console.WriteLine("Accuracy: " + accuracy);
    }
}
