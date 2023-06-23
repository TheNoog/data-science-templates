using System;
using XGBoost;

class Program
{
    static void Main(string[] args)
    {
        DMatrix trainMatrix, testMatrix;
        Booster booster;
        var trainPath = "train.libsvm";
        var testPath = "test.libsvm";
        var param = new Dictionary<string, string>
        {
            { "objective", "reg:squarederror" }
        };
        var numRounds = 100;

        // Load the training and testing data
        trainMatrix = new DMatrix(trainPath);
        testMatrix = new DMatrix(testPath);

        // Set the parameters
        booster = new Booster(param, new[] { trainMatrix });

        // Train the model
        for (int i = 0; i < numRounds; i++)
        {
            booster.UpdateOneIter(i, trainMatrix);
        }

        // Make predictions on the testing data
        var predictions = booster.Predict(testMatrix);

        // Evaluate the model
        var evalResult = booster.Evaluate(testMatrix);

        Console.WriteLine("Evaluation Result: " + evalResult);

        // Clean up resources
        trainMatrix.Dispose();
        testMatrix.Dispose();
        booster.Dispose();
    }
}
