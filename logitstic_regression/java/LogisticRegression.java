import java.util.Arrays;

public class LogisticRegression {

    private double[] weights;
    private double bias;

    public LogisticRegression(int featureCount) {
        weights = new double[featureCount];
        bias = 0.0;
    }

    public void train(double[] features, int label) {
        double prediction = sigmoid(dot(features, weights) + bias);
        double error = label - prediction;

        for (int i = 0; i < featureCount; i++) {
            weights[i] += error * features[i];
        }
        bias += error;
    }

    public int predict(double[] features) {
        double prediction = sigmoid(dot(features, weights) + bias);
        return prediction > 0.5 ? 1 : 0;
    }

    private double sigmoid(double x) {
        return 1.0 / (1.0 + Math.exp(-x));
    }

    private double dot(double[] x, double[] y) {
        double sum = 0.0;
        for (int i = 0; i < x.length; i++) {
            sum += x[i] * y[i];
        }
        return sum;
    }

    public static void main(String[] args) {
        double[] features = {1.0, 2.0};
        int label = 1;

        LogisticRegression model = new LogisticRegression(2);

        for (int i = 0; i < 100; i++) {
            model.train(features, label);
        }

        double[] newFeatures = {3.0, 4.0};
        int newLabel = model.predict(newFeatures);

        System.out.println("The predicted label is " + newLabel);
    }
}
