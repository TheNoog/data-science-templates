import java.util.Arrays;
import java.util.Random;

public class LassoRegression {

    // Define the number of samples and features
    private static final int N_SAMPLES = 100;
    private static final int N_FEATURES = 20;

    // Function to calculate the mean squared error
    private static double calculateMeanSquaredError(double[] yTrue, double[] yPred) {
        int n = yTrue.length;
        double mse = 0.0;
        for (int i = 0; i < n; i++) {
            double diff = yTrue[i] - yPred[i];
            mse += diff * diff;
        }
        return mse / n;
    }

    // Function to perform LASSO regression
    private static void lassoRegression(double[][] X, double[] y, double[] coefficients, double alpha) {
        // Maximum number of iterations for coordinate descent
        int maxIterations = 100;

        // Step size for coordinate descent
        double stepSize = 0.01;

        int nSamples = X.length;
        int nFeatures = X[0].length;

        // Initialize the coefficients to zero
        Arrays.fill(coefficients, 0.0);

        // Perform coordinate descent
        for (int iteration = 0; iteration < maxIterations; iteration++) {
            for (int j = 0; j < nFeatures; j++) {
                // Calculate the gradient for feature j
                double gradient = 0.0;
                for (int i = 0; i < nSamples; i++) {
                    double pred = 0.0;
                    for (int k = 0; k < nFeatures; k++) {
                        if (k != j) {
                            pred += X[i][k] * coefficients[k];
                        }
                    }
                    gradient += (y[i] - pred) * X[i][j];
                }

                // Update the coefficient using LASSO penalty
                if (gradient > alpha) {
                    coefficients[j] = (gradient - alpha) * stepSize;
                } else if (gradient < -alpha) {
                    coefficients[j] = (gradient + alpha) * stepSize;
                } else {
                    coefficients[j] = 0.0;
                }
            }
        }
    }

    // Generate some synthetic data
    private static double[][] generateSyntheticData() {
        double[][] X = new double[N_SAMPLES][N_FEATURES];
        double[] y = new double[N_SAMPLES];
        Random rng = new Random(42);

        for (int i = 0; i < N_SAMPLES; i++) {
            for (int j = 0; j < N_FEATURES; j++) {
                X[i][j] = rng.nextDouble();
            }

            y[i] = 0.0;
            for (int j = 0; j < N_FEATURES; j++) {
                y[i] += X[i][j] * (j + 1);
            }
            y[i] += 0.1 * rng.nextDouble();
        }

        return new double[][]{X, y};
    }

    public static void main(String[] args) {
        // Generate some synthetic data
        double[][] data = generateSyntheticData();
        double[][] X = data[0];
        double[] y = data[1];

        // Split the data into training and test sets
        int nTrainSamples = (int) (N_SAMPLES * 0.8);
        int nTestSamples = N_SAMPLES - nTrainSamples;
        double[][] XTrain = Arrays.copyOfRange(X, 0, nTrainSamples);
        double[] yTrain = Arrays.copyOfRange(y, 0, nTrainSamples);
        double[][] XTest = Arrays.copyOfRange(X, nTrainSamples, N_SAMPLES);
        double[] yTest = Arrays.copyOfRange(y, nTrainSamples, N_SAMPLES);

        // Perform LASSO regression
        double alpha = 0.1;
        double[] coefficients = new double[N_FEATURES];
        lassoRegression(XTrain, yTrain, coefficients, alpha);

        // Make predictions on the test set
        double[] yPred = new double[nTestSamples];
        for (int i = 0; i < nTestSamples; i++) {
            for (int j = 0; j < N_FEATURES; j++) {
                yPred[i] += XTest[i][j] * coefficients[j];
            }
        }

        // Calculate the mean squared error
        double mse = calculateMeanSquaredError(yTest, yPred);
        System.out.printf("Mean Squared Error: %.4f%n", mse);

        // Print the true coefficients and the estimated coefficients
        System.out.print("True Coefficients: [1.0 ");
        for (int i = 1; i < N_FEATURES; i++) {
            System.out.printf("%.4f ", i + 1.0);
        }
        System.out.println("]");

        System.out.print("Estimated Coefficients: [");
        for (double coeff : coefficients) {
            System.out.printf("%.4f ", coeff);
        }
        System.out.println("]");
    }
}
