import java.util.Arrays;

public class LDA {

    public static void LDA(double[] data, int n, int d, double[] coef, double[] means) {
        // Initialize the coef and means arrays.
        Arrays.fill(coef, 0.0);
        Arrays.fill(means, 0.0);

        // Calculate the means of the two classes.
        for (int i = 0; i < n; i++) {
            if (data[i * d] == 0) {
                means[0] += data[i * d];
            } else {
                means[1] += data[i * d];
            }
        }
        means[0] /= n / 2.0;
        means[1] /= n / 2.0;

        // Calculate the coef array.
        for (int i = 0; i < d; i++) {
            for (int j = 0; j < n; j++) {
                if (data[j * d] == 0) {
                    coef[i] += data[j * d] - means[0];
                } else {
                    coef[i] += data[j * d] - means[1];
                }
            }
            coef[i] /= n / 2.0;
        }
    }

    public static void main(String[] args) {
        // Initialize the data array.
        double[] data = new double[] {1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0};
        int n = 3;
        int d = 3;

        // Initialize the coef and means arrays.
        double[] coef = new double[d];
        double[] means = new double[d];

        // Calculate the coef and means arrays.
        LDA.LDA(data, n, d, coef, means);

        // Print the coef array.
        for (int i = 0; i < d; i++) {
            System.out.println(coef[i]);
        }

        // Print the means array.
        for (int i = 0; i < d; i++) {
            System.out.println(means[i]);
        }
    }
}
