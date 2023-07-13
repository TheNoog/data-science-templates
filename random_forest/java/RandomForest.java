import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class RandomForest {

    public static void main(String[] args) throws Exception {
        List<DataPoint> data = loadData("data.csv");
        List<Integer> treeLabels = createRandomForest(10);
        List<Integer> predictions = classifyData(data, treeLabels);
        float accuracy = calculateAccuracy(predictions, data);
        System.out.printf("Accuracy: %.2f%%\n", accuracy);
    }

    private static List<DataPoint> loadData(String filename) throws Exception {
        List<DataPoint> data = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] features = line.split(",");
                int label = Integer.parseInt(features[0]);
                float[] featureValues = new float[features.length - 1];
                for (int i = 1; i < features.length; i++) {
                    featureValues[i - 1] = Float.parseFloat(features[i]);
                }

                data.add(new DataPoint(label, featureValues));
            }
        }

        return data;
    }

    private static List<Integer> createRandomForest(int numTrees) {
        List<Integer> treeLabels = new ArrayList<>();
        Random random = new Random();
        for (int i = 0; i < numTrees; i++) {
            treeLabels.add(random.nextInt(2));
        }

        return treeLabels;
    }

    private static List<Integer> classifyData(List<DataPoint> data, List<Integer> treeLabels) {
        List<Integer> predictions = new ArrayList<>();
        for (DataPoint dp : data) {
            int correctLabel = dp.label;
            int prediction = 0;
            for (int treeLabel : treeLabels) {
                if (treeLabel == correctLabel) {
                    prediction++;
                }
            }

            predictions.add(prediction > numTrees / 2 ? 1 : 0);
        }

        return predictions;
    }

    private static float calculateAccuracy(List<Integer> predictions, List<DataPoint> data) {
        int correct = 0;
        for (int i = 0; i < predictions.size(); i++) {
            if (predictions.get(i) == data.get(i).label) {
                correct++;
            }
        }

        float accuracy = (float)correct / predictions.size();
        return accuracy * 100;
    }

    private static class DataPoint {
        int label;
        float[] features;

        public DataPoint(int label, float[] features) {
            this.label = label;
            this.features = features;
        }
    }
}
