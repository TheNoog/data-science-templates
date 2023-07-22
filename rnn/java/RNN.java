import java.util.ArrayList;
import java.util.List;

public class RNN {

    private int inputDim;
    private int hiddenDim;
    private int outputDim;

    private List<List<Double>> weights;
    private List<Double> biases;
    private List<Double> h;

    public RNN(int inputDim, int hiddenDim, int outputDim) {
        this.inputDim = inputDim;
        this.hiddenDim = hiddenDim;
        this.outputDim = outputDim;

        weights = new ArrayList<>();
        for (int i = 0; i < inputDim; i++) {
            weights.add(new ArrayList<Double>());
            for (int j = 0; j < hiddenDim; j++) {
                weights.get(i).add((double) Math.random() - 0.5);
            }
        }

        biases = new ArrayList<>();
        for (int i = 0; i < hiddenDim; i++) {
            biases.add((double) Math.random() - 0.5);
        }

        h = new ArrayList<>();
    }

    public void train(List<List<Double>> data) {
        for (List<Double> sequence : data) {
            h = new ArrayList<>();
            for (Double t : sequence) {
                double z = 0;
                for (int i = 0; i < inputDim; i++) {
                    z += t * weights.get(i).get(h.size());
                }
                h.add(Math.tanh(z + biases.get(h.size())));
            }
        }
    }

    public List<Double> predict(List<Double> data) {
        List<Double> predictions = new ArrayList<>();
        h = new ArrayList<>();
        for (Double t : data) {
            double z = 0;
            for (int i = 0; i < inputDim; i++) {
                z += t * weights.get(i).get(h.size());
            }
            h.add(Math.tanh(z + biases.get(h.size())));
            predictions.add(h.get(h.size() - 1));
        }
        return predictions;
    }
}
