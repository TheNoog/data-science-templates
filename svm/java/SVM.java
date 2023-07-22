import java.util.Arrays;

public class SVM {

    private double C;
    private String kernel;
    private double[] w;
    private double b;

    public SVM(double C, String kernel) {
        this.C = C;
        this.kernel = kernel;
        this.w = new double[]{0.0, 0.0};
        this.b = 0.0;
    }

    public void fit(double[][] X, int[] y, int n) {
        for (int i = 0; i < n; i++) {
            double score = 0.0;
            for (int j = 0; j < 2; j++) {
                score += w[j] * X[i][j];
            }
            if (y[i] * score + b <= 1.0) {
                for (int j = 0; j < 2; j++) {
                    w[j] += C * y[i] * X[i][j];
                }
                b += C * y[i];
            }
        }
    }

    public int predict(double[] X) {
        double score = 0.0;
        for (int j = 0; j < 2; j++) {
            score += w[j] * X[j];
        }
        return score >= 0.0 ? 1 : -1;
    }

    public static void main(String[] args) {
        SVM svm = new SVM(1.0, "linear");
        svm.fit(new double[][]{{1, 2}, {3, 4}}, new int[]{1, -1}, 2);
        System.out.println(svm.predict(new double[]{5, 6}));
    }
}
