import java.util.Arrays;
import java.util.List;

public class LinearRegression {
    // Function to calculate the mean
    public static double calculateMean(List<Double> list) {
        double sum = 0.0;
        for (double num : list) {
            sum += num;
        }
        return sum / list.size();
    }

    // Function to calculate the slope (beta1)
    public static double calculateSlope(List<Double> x, List<Double> y) {
        double meanX = calculateMean(x);
        double meanY = calculateMean(y);
        double numerator = 0.0;
        double denominator = 0.0;

        for (int i = 0; i < x.size(); i++) {
            numerator += (x.get(i) - meanX) * (y.get(i) - meanY);
            denominator += (x.get(i) - meanX) * (x.get(i) - meanX);
        }

        return numerator / denominator;
    }

    // Function to calculate the intercept (beta0)
    public static double calculateIntercept(List<Double> x, List<Double> y, double slope) {
        double meanX = calculateMean(x);
        double meanY = calculateMean(y);

        return meanY - slope * meanX;
    }

    // Function to make predictions
    public static double predict(double x, double slope, double intercept) {
        return slope * x + intercept;
    }

    public static void main(String[] args) {
        List<Double> x = Arrays.asList(1.0, 2.0, 3.0, 4.0, 5.0);  // Input features
        List<Double> y = Arrays.asList(2.0, 4.0, 5.0, 4.0, 6.0);  // Target variable

        double slope = calculateSlope(x, y);
        double intercept = calculateIntercept(x, y, slope);

        List<Double> newX = Arrays.asList(6.0, 7.0);

        System.out.println("Input\tPredicted Output");
        for (double num : newX) {
            double yPred = predict(num, slope, intercept);
            System.out.println(num + "\t" + yPred);
        }
    }
}
