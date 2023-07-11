import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Structure to represent a data point
class DataPoint {
    double x;
    double y;
    int label;

    DataPoint(double x, double y, int label) {
        this.x = x;
        this.y = y;
        this.label = label;
    }
}

public class KNN {
    // Function to calculate Euclidean distance between two data points
    static double calculateDistance(DataPoint p1, DataPoint p2) {
        double dx = p2.x - p1.x;
        double dy = p2.y - p1.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    // Function to perform KNN classification
    static int classify(List<DataPoint> trainingData, DataPoint testPoint, int k) {
        // Calculate distances to all training data points
        List<Double> distances = new ArrayList<>();
        for (DataPoint dataPoint : trainingData) {
            distances.add(calculateDistance(dataPoint, testPoint));
        }

        // Sort the distances in ascending order
        distances.sort(Comparator.naturalOrder());

        // Count the occurrences of each label among the k nearest neighbors
        Map<Integer, Integer> labelCount = new HashMap<>();
        for (int i = 0; i < k; i++) {
            int index = distances.indexOf(distances.get(i));
            int label = trainingData.get(index).label;
            labelCount.put(label, labelCount.getOrDefault(label, 0) + 1);
        }

        // Return the label with the highest count
        return labelCount.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(-1);
    }

    public static void main(String[] args) {
        // Training data
        List<DataPoint> trainingData = List.of(
                new DataPoint(2.0, 4.0, 0),
                new DataPoint(4.0, 6.0, 0),
                new DataPoint(4.0, 8.0, 1),
                new DataPoint(6.0, 4.0, 1),
                new DataPoint(6.0, 6.0, 1)
        );

        // Test data point
        DataPoint testPoint = new DataPoint(5.0, 5.0, 0);

        // Perform KNN classification
        int k = 3;
        int predictedLabel = classify(trainingData, testPoint, k);

        // Print the predicted label
        System.out.println("Predicted label: " + predictedLabel);
    }
}
