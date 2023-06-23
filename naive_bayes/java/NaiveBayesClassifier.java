package naive_bayes.java;

import java.util.ArrayList;
import java.util.List;

class DataPoint {
    private List<Double> features;
    private int label;

    public DataPoint(List<Double> features, int label) {
        this.features = features;
        this.label = label;
    }

    public List<Double> getFeatures() {
        return features;
    }

    public int getLabel() {
        return label;
    }
}

class Dataset {
    private List<DataPoint> data;

    public Dataset(List<DataPoint> data) {
        this.data = data;
    }

    public List<DataPoint> getData() {
        return data;
    }
}

public class NaiveBayesClassifier {

    private static final int NUM_CLASSES = 3;    // Number of classes in your dataset
    private static final int NUM_FEATURES = 4;   // Number of features in your dataset

    public static Dataset loadDataset() {
        // Load the dataset
        List<DataPoint> data = new ArrayList<>();

        // Your code to load the data from a file or any other source goes here
        // Add each data point as a DataPoint object to the data list

        return new Dataset(data);
    }

    public static void trainNaiveBayes(Dataset dataset, double[] priors, double[][] likelihoods) {
        int numDataPoints = dataset.getData().size();
        int[] classCounts = new int[NUM_CLASSES];

        // Count the occurrences of each class label
        for (DataPoint dataPoint : dataset.getData()) {
            classCounts[dataPoint.getLabel()]++;
        }

        // Calculate priors
        for (int i = 0; i < NUM_CLASSES; i++) {
            priors[i] = (double) classCounts[i] / numDataPoints;
        }

        // Calculate likelihoods
        for (int i = 0; i < NUM_CLASSES; i++) {
            for (int j = 0; j < NUM_FEATURES; j++) {
                double featureSum = 0.0;
                int featureCount = 0;

                // Sum the values of the feature for the current class
                for (DataPoint dataPoint : dataset.getData()) {
                    if (dataPoint.getLabel() == i) {
                        featureSum += dataPoint.getFeatures().get(j);
                        featureCount++;
                    }
                }

                // Calculate the average of the feature for the current class
                likelihoods[i][j] = featureSum / featureCount;
            }
        }
    }

    public static int predict(DataPoint dataPoint, double[] priors, double[][] likelihoods) {
        int numClasses = priors.length;
        int numFeatures = likelihoods[0].length;
        double maxPosterior = 0.0;
        int predictedClass = -1;

        // Calculate the posterior probability for each class
        for (int i = 0; i < numClasses; i++) {
            double posterior = priors[i];

            for (int j = 0; j < numFeatures; j++) {
                posterior *= Math.exp(-(Math.pow(dataPoint.getFeatures().get(j) - likelihoods[i][j], 2.0) / 2));
            }

            // Update the predicted class if the posterior is higher than the current maximum
            if (posterior > maxPosterior) {
                maxPosterior = posterior;
                predictedClass = i;
            }
        }

        return predictedClass;
    }

    public static void main(String[] args) {
        Dataset dataset = loadDataset();
        double[] priors = new double[NUM_CLASSES];
        double[][] likelihoods = new double[NUM_CLASSES][NUM_FEATURES];

        trainNaiveBayes(dataset, priors, likelihoods);

        // Example usage: Predict the class label for a new data point
        List<Double> newFeatures = List.of(5.1, 3.5, 1.4, 0.2);
        DataPoint newDataPoint = new DataPoint(newFeatures, 0);

        int predictedLabel = predict(newDataPoint, priors, likelihoods);
        System.out.println("Predicted Label: " + predictedLabel);
    }
}
